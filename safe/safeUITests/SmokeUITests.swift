//
//  Copyright © 2018 Gnosis. All rights reserved.
//

import XCTest

class SmokeUITests: XCTestCase {

    let application = Application()
    let password = "MyPassword1"

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application.resetAllContentAndSettings()
    }

    func test_setPasswordFlow() {
        application.start()

        let startScreen = StartScreen()
        startScreen.start()

        let setPasswordScreen = SetPasswordScreen()
        setPasswordScreen.enterPassword(password)

        let confirmPasswordScreen = ConfirmPasswordScreen()
        confirmPasswordScreen.enterPassword(password)

        let successScreen = PasswordSuccessScreen()
        XCTAssertTrue(successScreen.isDisplayed)
    }

    func test_unlock() {
        application.setPassword(password)
        application.start()

        let unlockScreen = UnlockScreen()
        unlockScreen.enterPassword(password)

        let setupSafeScreen = SetupSafeScreen()
        XCTAssertTrue(setupSafeScreen.isDisplayed)
    }

}
