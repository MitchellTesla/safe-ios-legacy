//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation

public protocol ExternallyOwnedAccountRepository {

    func save(_ account: ExternallyOwnedAccount)
    func remove(address: Address)
    func find(by address: Address) -> ExternallyOwnedAccount?

}
