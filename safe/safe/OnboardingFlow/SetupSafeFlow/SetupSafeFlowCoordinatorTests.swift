//
//  Copyright © 2018 Gnosis. All rights reserved.
//

import XCTest
@testable import safe

class SetupSafeFlowCoordinatorTests: XCTestCase {

    let setupSafeFlowCoordinator = SetupSafeFlowCoordinator()

    override func setUp() {
        super.setUp()
    }

    func test_startViewController() {
        XCTAssertTrue(setupSafeFlowCoordinator.startViewController() is UIViewController)
    }

}
