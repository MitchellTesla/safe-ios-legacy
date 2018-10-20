//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import UIKit
import SafeUIKit

class ScanButtonViewController: UIViewController {

    @IBOutlet weak var scanButton: ScanButton!
    @IBOutlet weak var scannedCodeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        scannedCodeLabel.text = nil
        scanButton.delegate = self
        scanButton.scanValidatedConverter = { $0 }
        scanButton.addDebugButtonToScannerController(title: "Scan Test Value", scanValue: "Test Value")
    }

}

extension ScanButtonViewController: ScanButtonDelegate {

    func presentController(_ controller: UIViewController) {
        present(controller, animated: true)
    }

    func didScanValidCode(_ button: ScanButton, code: String) {
        scanButton.checkmarkStatus = .selected
        scannedCodeLabel.text = code
    }

}
