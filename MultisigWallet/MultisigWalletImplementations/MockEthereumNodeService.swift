//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation
import MultisigWalletDomainModel
import BigInt

public class MockEthereumNodeService: EthereumNodeDomainService {

    enum Error: String, LocalizedError, Hashable {
        case error
    }

    public var shouldThrow = false

    public init() {}

    public var eth_getBalance_output: BigInt?

    public func eth_getBalance(account: Address) throws -> BigInt {
        if shouldThrow { throw Error.error }
        return eth_getBalance_output ?? 0
    }

    public var eth_getTransactionReceipt_output: TransactionReceipt?

    public func eth_getTransactionReceipt(transaction: TransactionHash) throws -> TransactionReceipt? {
        if shouldThrow { throw Error.error }
        return eth_getTransactionReceipt_output
    }

    public var eth_call_input: (to: Address, data: Data)?
    public var eth_call_output = Data()

    public func eth_call(to: Address, data: Data) throws -> Data {
        eth_call_input = (to, data)
        return eth_call_output
    }

}
