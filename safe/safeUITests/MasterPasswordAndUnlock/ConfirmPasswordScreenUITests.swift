//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import XCTest
import CommonTestSupport

class ConfirmPasswordScreenUITests: XCTestCase {

    let application = Application()
    let screen = ConfirmPasswordScreen()
    let validPassword = "abcdeF1"
    let invalidPassword = "a"

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application.resetAllContentAndSettings()
    }

    // MP-004
    func test_contents() {
        givenConfirmPasswordScreen()
        XCTAssertExist(screen.title)
        XCTAssertExist(screen.passwordField)
        XCTAssertTrue(screen.isKeyboardActive)
        XCTAssertExist(screen.passwordMatchRule.element)
        XCTAssertEqual(screen.passwordMatchRule.state, .inactive)
    }

    // MP-005
    func test_whenSessionInvalidatedAndAppRestoredToForeground_confirmScreenIsDisplayed() {
        let sessionDurationInSeconds: TimeInterval = 1
        application.setSessionDuration(seconds: sessionDurationInSeconds)
        givenConfirmPasswordScreen()

        application.minimize()
        delay(sessionDurationInSeconds + 1)

        application.maximize()
        XCTAssertTrue(screen.isDisplayed)
    }

    // MP-006
    func test_whenAppRestarted_itStartsOnStartScreen() {
        givenConfirmPasswordScreen()
        application.terminate()
        application.start()
        XCTAssertTrue(StartScreen().isDisplayed)
    }

    // MP-007
    func test_whenEnteredDifferentPassword_thenRuleError() {
        givenConfirmPasswordScreen()
        screen.enterPassword(invalidPassword)
        XCTAssertEqual(screen.passwordMatchRule.state, .error)
    }

    // MP-007
    func test_whenEnteredMatchingPassword_thenRuleSuccess() {
        givenConfirmPasswordScreen()
        screen.enterPassword(validPassword, hittingEnter: false)
        XCTAssertEqual(screen.passwordMatchRule.state, .success)
    }

    // MP-007
    func test_whenEnteredMatchingPasswordAndHitEnter_thenSafeSetupOptionsScreenDisplayed() {
        givenConfirmPasswordScreen()
        screen.enterPassword(validPassword)
        XCTAssertTrue(SetupSafeOptionsScreen().isDisplayed)
    }

}

extension ConfirmPasswordScreenUITests {

    private func givenConfirmPasswordScreen() {
        application.start()
        StartScreen().start()
        SetPasswordScreen().enterPassword(validPassword)
    }

}
