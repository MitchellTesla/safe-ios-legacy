//
//  Copyright © 2018 Gnosis. All rights reserved.
//

import Foundation
import XCTest

final class TestUtils {

    private init() {}

    static func enterText(_ text: String) {
        XCUIApplication().secureTextFields.firstMatch.typeText(text + "\n")
    }

}
