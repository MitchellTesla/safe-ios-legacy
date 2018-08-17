//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import XCTest
@testable import MultisigWalletDomainModel
import CommonTestSupport

class RepeatTests: XCTestCase {

    func test_whenStarted_thenRepeatsUntilStopped() throws {
        var counter = 0
        let rep = Repeat(delay: 0) { rep in
            counter += 1
            if counter == 2 {
                rep.stop()
            }
        }
        try rep.start()
        XCTAssertEqual(counter, 2)
    }

    func test_whenThrowing_thenRethrows() throws {
        let rep = Repeat(delay: 0) { _ in
            throw TestError.error
        }
        XCTAssertThrowsError(try rep.start())
    }

}
