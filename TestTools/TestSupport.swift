//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation
import IdentityAccessApplication

protocol Resettable: class {
    func resetAll()
}

final class TestSupport {

    static let shared = TestSupport()
    private var resettableObjects = [Resettable]()
    private var authenticationService: AuthenticationApplicationService {
        return ApplicationServiceRegistry.authenticationService
    }

    func addResettable(_ object: Resettable) {
        resettableObjects.append(object)
    }

    func setUp(_ arguments: [String] = ProcessInfo.processInfo.arguments) {
        var iterator = arguments.makeIterator()
        while let argument = iterator.next() {
            switch argument {
            case ApplicationArguments.resetAllContentAndSettings:
                resettableObjects.forEach { $0.resetAll() }
            case ApplicationArguments.setPassword:
                if let password = iterator.next() {
                    try? authenticationService.registerUser(password: password)
                }
            case ApplicationArguments.setSessionDuration:
                if let duration = timeInterval(&iterator) {
                    authenticationService.configureSession(duration)
                }
            case ApplicationArguments.setMaxPasswordAttempts:
                if let attemptCountStr = iterator.next(),
                    let attemptCount = Int(attemptCountStr) {
                    authenticationService.configureMaxPasswordAttempts(attemptCount)
                }
            case ApplicationArguments.setAccountBlockedPeriodDuration:
                if let blockingTime = timeInterval(&iterator) {
                    authenticationService.configureBlockDuration(blockingTime)
                }
            default: break
            }
        }
    }

    private func timeInterval(_ iterator: inout IndexingIterator<[String]>) -> TimeInterval? {
        if let string = iterator.next(),
            let time = TimeInterval(string) {
            return time
        }
        return nil
    }

}