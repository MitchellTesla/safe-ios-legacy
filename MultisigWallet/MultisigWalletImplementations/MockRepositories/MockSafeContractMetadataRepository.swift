//
//  Copyright © 2019 Gnosis Ltd. All rights reserved.
//

import Foundation
import MultisigWalletDomainModel

public class MockSafeContractMetadataRepository: SafeContractMetadataRepository {

    public var multiSendContractAddress: Address
    public var proxyFactoryAddress: Address
    public var fallbackHandlerAddress: Address
    public var latestMasterCopyAddress: Address

    public init() {
        multiSendContractAddress = Address("0x0000000000000000000000000000000000000001")
        proxyFactoryAddress = Address("0x0000000000000000000000000000000000000002")
        fallbackHandlerAddress = Address("0x0000000000000000000000000000000000000003")
        latestMasterCopyAddress = Address("0x0000000000000000000000000000000000000004")
    }

    public var isOldMasterCopy_result: Bool = false

    public func isOldMasterCopy(address: Address) -> Bool {
        isOldMasterCopy_result
    }

    public func isValidMasterCopy(address: Address) -> Bool {
        false
    }

    public func isValidProxyFactory(address: Address) -> Bool {
        false
    }

    public func isValidPaymentRecevier(address: Address) -> Bool {
        false
    }

    public func version(masterCopyAddress: Address) -> String? {
        nil
    }

    public var contractVersion = ""
    public func latestContractVersion() -> String {
        contractVersion
    }

    public func deploymentCode(masterCopyAddress: Address) -> Data {
        return Data()
    }

    public func EIP712SafeAppTxTypeHash(masterCopyAddress: Address) -> Data? {
        nil
    }

    public func EIP712SafeAppDomainSeparatorTypeHash(masterCopyAddress: Address) -> Data? {
        nil
    }

    public func version(multiSendAddress: Address) -> Int? {
        nil
    }

    public func isValidMultiSend(address: Address) -> Bool {
        false
    }

}
