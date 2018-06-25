//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation

public protocol WalletRepository {

    func save(_ wallet: Wallet) throws
    func remove(_ wallet: Wallet) throws
    func findByID(_ walletID: WalletID) throws -> Wallet?
    func nextID() -> WalletID

}
