//
//  Copyright © 2019 Gnosis Ltd. All rights reserved.
//

import UIKit
import SafeUIKit
import IdentityAccessApplication

protocol VerifyCurrentPasswordViewControllerDelegate: class {
    func didVerifyPassword()
}

final class VerifyCurrentPasswordViewController: UIViewController {

    private weak var delegate: VerifyCurrentPasswordViewControllerDelegate!

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var passwordInput: VerifiableInput!
    @IBOutlet weak var countdownStack: UIStackView!
    @IBOutlet weak var tryAgainInLabel: UILabel!
    @IBOutlet weak var countdownLabel: CountdownLabel!

    private var authenticationService: AuthenticationApplicationService {
        return ApplicationServiceRegistry.authenticationService
    }

    static func create(delegate: VerifyCurrentPasswordViewControllerDelegate) -> VerifyCurrentPasswordViewController {
        let vc = StoryboardScene.ChangePassword.verifyCurrentPasswordViewController.instantiate()
        vc.delegate = delegate
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordInput.isSecure = true
        passwordInput.delegate = self
    }

    private func startCountdownIfNeeded() {
        guard authenticationService.isAuthenticationBlocked else {
            countdownStack.isHidden = true
            return
        }
        countdownStack.isHidden = false
        passwordInput.isEnabled = false
        countdownLabel.start { [weak self] in
            guard let `self` = self else { return }
            self.passwordInput.isEnabled = true
            self.countdownStack.isHidden = true
            _ = self.passwordInput.becomeFirstResponder()
        }
    }

}

extension VerifyCurrentPasswordViewController: VerifiableInputDelegate {

    func verifiableInputDidReturn(_ verifiableInput: VerifiableInput) {
        do {
            let result = try Authenticator.instance.authenticate(.password(verifiableInput.text!))
            if result.isSuccess {
                delegate.didVerifyPassword()
            } else {
                verifiableInput.shake()
                startCountdownIfNeeded()
            }
        } catch let e {
            ErrorHandler.showFatalError(log: "Failed to authenticate with password", error: e)
        }
    }

}
