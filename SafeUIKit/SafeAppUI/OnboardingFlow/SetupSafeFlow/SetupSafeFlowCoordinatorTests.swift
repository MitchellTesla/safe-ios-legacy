//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import XCTest
@testable import SafeAppUI
import CommonTestSupport

class SetupSafeFlowCoordinatorTests: SafeTestCase {

    var setupSafeFlowCoordinator: SetupSafeFlowCoordinator!
    var newSafeFlowCoordinator: NewSafeFlowCoordinator!

    override func setUp() {
        super.setUp()
        setupSafeFlowCoordinator = SetupSafeFlowCoordinator(rootViewController: UINavigationController())
        newSafeFlowCoordinator = NewSafeFlowCoordinator()
        setupSafeFlowCoordinator.setUp()
    }

    func test_whenNoSafeSelected_thenShowsOptionsScreen() {
        XCTAssertTrue(setupSafeFlowCoordinator.navigationController.topViewController is SetupSafeOptionsViewController)
    }

    func test_whenDraftAlreadyExists_thenShowsNewSafeFlow() {
        walletService.createNewDraftWallet()

        let testFC = TestFlowCoordinator()
        testFC.enter(flow: setupSafeFlowCoordinator)
        delay()

        XCTAssertEqual(testFC.navigationController.viewControllers.count, 2)
        XCTAssertTrue(testFC.navigationController.viewControllers.last is NewSafeViewController)
    }

    func test_didSelectNewSafe_showsNewSafeFlowStartVC() {
        let testFC = TestFlowCoordinator()
        testFC.enter(flow: setupSafeFlowCoordinator)

        setupSafeFlowCoordinator.didSelectNewSafe()
        delay()
        let newSafeStartVC = testFC.topViewController
        XCTAssertTrue(type(of: setupSafeFlowCoordinator.navigationController.topViewController) ==
            type(of: newSafeStartVC))
    }

}
