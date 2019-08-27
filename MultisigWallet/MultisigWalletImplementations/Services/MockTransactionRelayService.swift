//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation
import MultisigWalletDomainModel
import Common
import CommonTestSupport

public class MockTransactionRelayService: TransactionRelayDomainService {

    public let averageDelay: Double
    public let maxDeviation: Double

    public var shouldThrowNetworkError = false
    public var shouldThrow = false

    private var randomizedNetworkResponseDelay: Double {
        return Timer.random(average: averageDelay, maxDeviation: maxDeviation)
    }

    public init(averageDelay: Double, maxDeviation: Double) {
        self.averageDelay = averageDelay
        self.maxDeviation = fabs(maxDeviation)
    }

    public var startSafeCreation_input: Address?

    public func startSafeCreation(address: Address) throws {
        try throwIfNeeded()
        startSafeCreation_input = address
        Timer.wait(randomizedNetworkResponseDelay)
    }

    public func safeCreationTransactionHash(address: Address) throws -> TransactionHash? {
        try throwIfNeeded()
        Timer.wait(randomizedNetworkResponseDelay)
        return TransactionHash("0x3b9307c1473e915d04292a0f5b0f425eaf527f53852357e2c649b8c447e3246a")
    }

    public func safeCreationTransactionBlock(address: Address) throws -> StringifiedBigInt? {
        return StringifiedBigInt(123)
    }

    public func gasPrice() throws -> SafeGasPriceResponse {
        try throwIfNeeded()
        Timer.wait(randomizedNetworkResponseDelay)
        return SafeGasPriceResponse(safeLow: "0", standard: "0", fast: "0", fastest: "0", lowest: "0")
    }

    public var submitTransaction_input: SubmitTransactionRequest?
    public var submitTransaction_output = SubmitTransactionRequest.Response(transactionHash: "")

    public func submitTransaction(request: SubmitTransactionRequest) throws -> SubmitTransactionRequest.Response {
        try throwIfNeeded()
        submitTransaction_input = request
        return submitTransaction_output
    }

    public var estimateTransaction_input: EstimateTransactionRequest?
    public var estimateTransaction_output: EstimateTransactionRequest.Response =
        .init(safeTxGas: 100,
              dataGas: 100,
              operationalGas: 100,
              gasPrice: 100,
              lastUsedNonce: 11,
              gasToken: "0x0000000000000000000000000000000000000000")

    public func estimateTransaction(request: EstimateTransactionRequest) throws -> EstimateTransactionRequest.Response {
        try throwIfNeeded()
        estimateTransaction_input = request
        return estimateTransaction_output
    }

    private func throwIfNeeded() throws {
        if shouldThrowNetworkError {
            throw HTTPClient.Error.networkRequestFailed(URLRequest(url: URL(string: "http://test.url")!), nil, nil)
        }
        if shouldThrow { throw TestError.error }
    }

    public func createSafeCreationTransaction(request: SafeCreationRequest) throws
        -> SafeCreationRequest.Response {
            preconditionFailure("not implemented")
    }

    public var estimateSafeCreation_input: EstimateSafeCreationRequest?
    public var estimateSafeCreation_outputEstimations = [EstimateSafeCreationRequest.Estimation]()
    public func estimateSafeCreation(request: EstimateSafeCreationRequest) throws ->
        [EstimateSafeCreationRequest.Estimation] {
        try throwIfNeeded()
        estimateSafeCreation_input = request
        return estimateSafeCreation_outputEstimations
    }

    public func multiTokenEstimateTransaction(request: MultiTokenEstimateTransactionRequest) throws ->
        MultiTokenEstimateTransactionRequest.Response {
            return .init(lastUsedNonce: nil, safeTxGas: nil, operationalGas: nil, estimations: [])
    }

    public func safeExists(at address: Address) throws -> Bool {
        return true
    }

}
