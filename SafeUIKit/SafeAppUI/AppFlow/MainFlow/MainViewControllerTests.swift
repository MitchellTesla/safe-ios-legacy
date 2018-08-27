//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import XCTest
@testable import SafeAppUI
import MultisigWalletApplication
import Common
import BigInt

class MainViewControllerTests: XCTestCase {

    let walletService = MockWalletApplicationService()
    // swiftlint:disable weak_delegate
    let delegate = MockMainViewControllerDelegate()
    var vc: MainViewController!

    override func setUp() {
        super.setUp()
        ApplicationServiceRegistry.put(service: MockLogger(), for: Logger.self)
        ApplicationServiceRegistry.put(service: walletService, for: WalletApplicationService.self)

        vc = MainViewController.create(delegate: delegate)
    }

    func test_whenPressingSend_thenCallsDelegate() {
        vc.send(self)
        XCTAssertTrue(delegate.didCallCreateNewTransaction)
    }

    func test_whenPressingMenu_thenCallsDelegate() {
        vc.openMenu(self)
        XCTAssertTrue(delegate.didCallOpenMenu)
    }

    func test_whenPressingManageTokens_thenCallsDelegate() {
        vc.manageTokens(self)
        XCTAssertTrue(delegate.didCallManageTokens)
    }

}

class MockMainViewControllerDelegate: MainViewControllerDelegate {

    func mainViewDidAppear() {}

    var didCallCreateNewTransaction = false
    func createNewTransaction() {
        didCallCreateNewTransaction = true
    }

    var didCallOpenMenu = false
    func openMenu() {
        didCallOpenMenu = true
    }

    var didCallManageTokens = false
    func manageTokens() {
        didCallManageTokens = true
    }

}
