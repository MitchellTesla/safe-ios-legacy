//
//  Copyright © 2019 Gnosis Ltd. All rights reserved.
//

import Foundation

public protocol WalletConnectSessionRepository {

    func save(_ item: WCSession)
    func remove(_ item: WCSession)
    func find(id: WCSessionID) -> WCSession?
    func find(url: WCURL) -> WCSession?
    func all() -> [WCSession]

}

public extension WalletConnectSessionRepository {

    func find(url: WCURL) -> WCSession? {
        return all().first { $0.url == url }
    }

}

public protocol WCTransaction {
    var transactionID: TransactionID { get }
    var completion: (Result<String, Error>) -> Void { get }
}

public protocol WCProcessingTransactionsRepository {
    func add(transaction: WCTransaction)
    func find(transactionID: TransactionID) -> WCTransaction?
    func remove(transactionID: TransactionID)
}
