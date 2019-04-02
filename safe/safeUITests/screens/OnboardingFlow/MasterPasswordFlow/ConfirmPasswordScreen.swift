//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation
import XCTest
import CommonTestSupport

final class ConfirmPasswordScreen: SecureTextfieldScreen {

    override var title: XCUIElement {
        return XCUIApplication().navigationBars[LocalizedString("onboarding.confirm_password.title")]
    }
    let passwordMatchRule = Rule(key: "onboarding.confirm_password.match")

}
