//
//  Copyright © 2018 Gnosis. All rights reserved.
//

import Foundation
@testable import safe

class MockAccount: AccountProtocol {

    var hasMasterPassword = false
    var isLoggedIn = false

    var didSavePassword = false
    var didCleanData = false
    var didRequestBiometricActivation = false
    var setMasterPasswordThrows = false
    private var biometricActivationCompletion: (() -> Void)?

    var didRequestBiometricAuthentication = false
    var shouldCallBiometricCompletionImmediately = true
    private var biometricAuthenticationCompletion: ((Bool) -> Void)?

    var didRequestPasswordAuthentication = false
    var shouldAuthenticateWithPassword = false

    enum Error: Swift.Error {
        case error
    }

    func cleanupAllData() {
        didCleanData = true
    }

    func setMasterPassword(_ password: String) throws {
        if setMasterPasswordThrows {
            throw Error.error
        }
        didSavePassword = true
    }

    func activateBiometricAuthentication(completion: @escaping () -> Void) {
        didRequestBiometricActivation = true
        biometricActivationCompletion = completion
    }

    func finishBiometricActivation() {
        biometricActivationCompletion?()
    }

    func authenticateWithBiometry(completion: @escaping (Bool) -> Void) {
        didRequestBiometricAuthentication = true
        if shouldCallBiometricCompletionImmediately {
            completion(true)
        } else {
            biometricAuthenticationCompletion = completion
        }
    }

    func completeBiometryAuthentication(success: Bool) {
        biometricAuthenticationCompletion?(success)
    }

    func authenticateWithPassword(_ password: String) -> Bool {
        didRequestPasswordAuthentication = true
        return shouldAuthenticateWithPassword
    }

}
