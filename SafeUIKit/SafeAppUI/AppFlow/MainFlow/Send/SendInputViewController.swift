//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import UIKit
import MultisigWalletApplication
import Common
import SafeUIKit

protocol SendInputViewControllerDelegate: class {
    func didCreateDraftTransaction(id: String)
}

public class SendInputViewController: UIViewController {

    @IBOutlet var backgroundView: BackgroundImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    @IBOutlet weak var transactionHeaderView: TransactionHeaderView!
    @IBOutlet weak var addressInput: AddressInput!
    @IBOutlet weak var tokenInput: TokenInput!

    // Either transactionFeeView or tokenBalanceView and feeBalanceView are visible at the same time
    @IBOutlet weak var transactionFeeView: TransactionFeeView!

    @IBOutlet weak var tokenBalanceView: TransactionFeeView!
    @IBOutlet weak var feeBalanceView: TransactionFeeView!
    @IBOutlet weak var feeBackgroundView: UIView!

    weak var delegate: SendInputViewControllerDelegate?

    private var keyboardBehavior: KeyboardAvoidingBehavior!
    internal var model: SendInputViewModel!
    internal var transactionID: String?

    private var tokenID: BaseID!
    private let feeTokenID: BaseID = ethID

    public static func create(tokenID: BaseID) -> SendInputViewController {
        let controller = StoryboardScene.Main.sendInputViewController.instantiate()
        controller.tokenID = tokenID
        return controller
    }

    private enum Strings {
        static let titleFormatString = LocalizedString("send_title", comment: "Send")
        static let `continue` = LocalizedString("review", comment: "Review button for Send screen")

        // errors
        static let notEnoughFunds = LocalizedString("exceeds_funds",
                                                    comment: "Not enough balance for transaction.")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = .white
        backgroundView.isDimmed = true
        nextBarButton.title = SendInputViewController.Strings.continue
        nextBarButton.accessibilityIdentifier = "transaction.continue"
        keyboardBehavior = KeyboardAvoidingBehavior(scrollView: scrollView)

        model = SendInputViewModel(tokenID: tokenID, onUpdate: updateFromViewModel)

        navigationItem.title = String(format: Strings.titleFormatString, model.tokenData.code)

        addressInput.addressInputDelegate = self
        addressInput.textInput.accessibilityIdentifier = "transaction.address"

        tokenInput.addRule(Strings.notEnoughFunds, identifier: "notEnoughFunds") { [unowned self] in
            guard self.tokenInput.formatter.number(from: $0) != nil else { return true }
            self.model.change(amount: $0)
            return self.model.hasEnoughFunds() ?? false
        }
        tokenInput.setUp(value: 0, decimals: model.tokenData.decimals)
        tokenInput.usesEthDefaultImage = true
        tokenInput.imageURL = model.tokenData.logoURL
        tokenInput.tokenCode = model.tokenData.code
        tokenInput.delegate = self
        tokenInput.textInput.accessibilityIdentifier = "transaction.amount"

        transactionHeaderView.usesEthImageWhenImageURLIsNil = true
        feeBalanceView.backgroundColor = .clear
        feeBackgroundView.backgroundColor = .white
        model.start()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardBehavior.start()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackEvent(SendTrackingEvent(.input, token: model.tokenData.address, tokenName: model.tokenData.code))
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardBehavior.stop()
    }

    func updateFromViewModel() {
        transactionHeaderView.assetCode = model.tokenData.code
        transactionHeaderView.assetImageURL = model.tokenData.logoURL
        transactionHeaderView.assetInfo = model.balance
        if tokenID == feeTokenID {
            transactionFeeView.isHidden = false
            tokenBalanceView.isHidden = true
            feeBalanceView.isHidden = true
            feeBackgroundView.isHidden = true
            transactionFeeView.configure(currentBalance: model.feeBalanceTokenData,
                                         transactionFee: model.feeAmountTokenData,
                                         resultingBalance: model.feeResultingBalanceTokenData)
        } else {
            transactionFeeView.isHidden = true
            tokenBalanceView.isHidden = false
            feeBalanceView.isHidden = false
            feeBackgroundView.isHidden = false
            tokenBalanceView.configure(currentBalance: model.tokenData,
                                       transactionFee: nil,
                                       resultingBalance: model.resultingTokenData)
            feeBalanceView.configure(currentBalance: nil,
                                     transactionFee: model.feeAmountTokenData,
                                     resultingBalance: model.feeResultingBalanceTokenData)
        }
        nextBarButton.isEnabled = model.canProceedToSigning
    }

    @IBAction func proceedToSigning(_ sender: Any) {
        let service = ApplicationServiceRegistry.walletService
        transactionID = service.createNewDraftTransaction()
        service.updateTransaction(transactionID!,
                                  amount: model.intAmount ?? 0,
                                  token: tokenID.id,
                                  recipient: model.recipient!)
        delegate?.didCreateDraftTransaction(id: transactionID!)
    }

    func willBeRemoved() {
        if let id = transactionID {
            DispatchQueue.main.async {
                ApplicationServiceRegistry.walletService.removeDraftTransaction(id)
            }
        }
    }

    @objc func showTransactionFeeInfo() {
        present(TransactionFeeAlertController.create(), animated: true, completion: nil)
    }

}

extension SendInputViewController: AddressInputDelegate {

    public func didRecieveInvalidAddress(_ string: String) {}

    public func didClear() {}

    public func presentController(_ controller: UIViewController) {
        self.present(controller, animated: true)
    }

    public func didRecieveValidAddress(_ address: String) {
        model.change(recipient: address)
    }

}

extension SendInputViewController: VerifiableInputDelegate {

    public func verifiableInputDidReturn(_ verifiableInput: VerifiableInput) {
        if model.canProceedToSigning {
            proceedToSigning(verifiableInput)
        }
    }

    public func verifiableInputDidBeginEditing(_ verifiableInput: VerifiableInput) {
        keyboardBehavior.activeTextField = verifiableInput.textInput
    }

}