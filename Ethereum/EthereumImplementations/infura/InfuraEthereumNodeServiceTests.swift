//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import XCTest
@testable import EthereumImplementations
import EthereumDomainModel

class InfuraEthereumNodeServiceTests: XCTestCase {

    let service = InfuraEthereumNodeService()
    let testAddress = Address(value: "0x57b2573E5FA7c7C9B5Fa82F3F03A75F53A0efdF5")
    let emptyAddress = Address(value: "0xd1776c60688a3277c7e69204849989c7dc9f5aaa")
    let notExistingTransactionHash =
        TransactionHash(value: "0xaaaad132ec7112c08c166fbdc7f87a4e17ee00aaaa4c67eb7fde3cab53c60abe")
    let successfulTransactionHash =
        TransactionHash(value: "0x5b448bad86b814dc7aab866f32ffc3d22f140cdcb6c24116548ede8e6e4d343b")
    let failedTransactionHash =
        TransactionHash(value: "0x1b6efea55bb515fd8599d543f57b54ec3ed4242c887269f1a2e9e0008c15ccaf")

    private func test_whenAccountNotExists_thenReturnsZero() throws {
        XCTAssertEqual(try service.eth_getBalance(account: emptyAddress), Ether.zero)
    }

    private func test_whenBalanceCheckedInBackground_thenItIsFetched() throws {
        var balance: Ether?
        let exp = expectation(description: "wait")
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            balance = try? self.service.eth_getBalance(account: self.testAddress)
            exp.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(balance, Ether(amount: 30_000_000_000_000_000))
    }

    private func test_whenExecutedOnMainThread_thenNotLocked() throws {
        assert(Thread.isMainThread)
        // if the line below doesn't block the main thread, then this test passes. Otherwise, it will lock forever.
        _ = try self.service.eth_getBalance(account: testAddress)
    }

    private func test_whenTransactionDoesNotExist_thenReceiptIsNil() throws {
        XCTAssertNil(try service.eth_getTransactionReceipt(transaction: notExistingTransactionHash))
    }

    private func test_whenTransactionCompletedSuccess_thenReceiptExists() throws {
        XCTAssertEqual(try service.eth_getTransactionReceipt(transaction: successfulTransactionHash),
                       TransactionReceipt(hash: successfulTransactionHash, status: .success))
    }

    private func test_whenTransactionWasDeclined_thenReceiptStatusIsFailed() throws {
        XCTAssertEqual(try service.eth_getTransactionReceipt(transaction: failedTransactionHash),
                       TransactionReceipt(hash: failedTransactionHash, status: .failed))
    }

}
