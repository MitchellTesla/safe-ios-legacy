//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import XCTest
@testable import MultisigWalletDomainModel

class WalletTests: XCTestCase {

    var wallet: Wallet!
    let owner = Owner(address: BlockchainAddress(value: "My Address"))

    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(wallet = Wallet(id: try WalletID()))
    }

    func test_init_whenCreated_thenHasID() throws {
        XCTAssertNotNil(wallet.id)
    }

    func test_whenAddingOwner_thenHasOwner() throws {
        try wallet.addOwner(owner, kind: "kind")
        XCTAssertEqual(wallet.owner(kind: "kind"), owner)
    }

    func test_whenAddingOwnerTwice_thenThrows() throws {
        try wallet.addOwner(owner, kind: "kind")
        XCTAssertThrowsError(try wallet.addOwner(owner, kind: "kind"))
    }

    func test_whenReplacingOwner_thenAnotherOwnerExists() throws {
        let otherOwner = Owner(address: BlockchainAddress(value: "Other"))
        try wallet.addOwner(owner, kind: "kind")
        try wallet.replaceOwner(with: otherOwner, kind: "kind")
        XCTAssertEqual(wallet.owner(kind: "kind"), otherOwner)
        XCTAssertNil(wallet.owner(kind: "inexistingKind"))
    }

    func test_whenReplacingNotExistingOwner_thenThrows() throws {
        XCTAssertThrowsError(try wallet.replaceOwner(with: owner, kind: "kind"))
    }

    func test_whenRemovingInexistingOwner_thenThrows() throws {
        XCTAssertThrowsError(try wallet.removeOwner(kind: "kind"))
    }

    func test_whenRemovingOwner_thenItDoesNotExist() throws {
        try wallet.addOwner(owner, kind: "kind")
        try wallet.removeOwner(kind: "kind")
        XCTAssertNil(wallet.owner(kind: "kind"))
    }

    func test_whenCreated_thenInDraftState() throws {
        XCTAssertEqual(wallet.status, .newDraft)
    }

    func test_whenDeploymentStarted_thenChangesState() throws {
        try wallet.markReadyToDeploy()
        try wallet.startDeployment()
        XCTAssertEqual(wallet.status, Wallet.Status.deploymentStarted)
    }

    func test_whenDeploymentCompleted_thenChangesStatus() throws {
        try wallet.markReadyToDeploy()
        try wallet.startDeployment()
        try wallet.changeBlockchainAddress(BlockchainAddress(value: "address"))
        try wallet.markDeploymentAcceptedByBlockchain()
        try wallet.markDeploymentSuccess()
        try wallet.finishDeployment()
        XCTAssertEqual(wallet.status, Wallet.Status.readyToUse)
    }

    func test_whenStartsDeploymentInWrongState_thenThrows() throws {
        try wallet.markReadyToDeploy()
        try wallet.startDeployment()
        try wallet.changeBlockchainAddress(BlockchainAddress(value: "address"))
        try wallet.markDeploymentAcceptedByBlockchain()
        try wallet.markDeploymentSuccess()
        try wallet.finishDeployment()
        XCTAssertThrowsError(try wallet.startDeployment())
    }

    func test_whenCompletesDeploymentInWrongState_thenThrows() throws {
        XCTAssertThrowsError(try wallet.finishDeployment())
    }

    func test_whenTryingToAddOwnerInPendingState_thenThrows() throws {
        try wallet.markReadyToDeploy()
        try wallet.startDeployment()
        XCTAssertThrowsError(try wallet.addOwner(owner, kind: "kind"))
    }

    func test_whenTryingToRemoveOwnerWhenInPendingState_thenThrows() throws {
        try wallet.addOwner(owner, kind: "kind")
        try wallet.markReadyToDeploy()
        try wallet.startDeployment()
        XCTAssertThrowsError(try wallet.removeOwner(kind: "kind"))
    }

    func test_whenTryingToReplaceOwnerWhilePending_thenThrows() throws {
        let otherOwner = Owner(address: BlockchainAddress(value: "Other"))
        try wallet.addOwner(owner, kind: "kind")
        try wallet.markReadyToDeploy()
        try wallet.startDeployment()
        XCTAssertThrowsError(try wallet.replaceOwner(with: otherOwner, kind: "kind"))
    }

    func test_whenCancellingDeployment_thenChangesState() throws {
        try wallet.markReadyToDeploy()
        try wallet.startDeployment()
        try wallet.changeBlockchainAddress(BlockchainAddress(value: "address"))
        try wallet.markDeploymentAcceptedByBlockchain()
        try wallet.abortDeployment()
        XCTAssertEqual(wallet.status, .newDraft)
    }

    func test_whenTryingToCancelDeplolymentWhileNotDeploying_thenThrows() throws {
        XCTAssertThrowsError(try wallet.abortDeployment())
        try wallet.markReadyToDeploy()
        try wallet.startDeployment()
        try wallet.changeBlockchainAddress(BlockchainAddress(value: "address"))
        try wallet.markDeploymentAcceptedByBlockchain()
        try wallet.markDeploymentSuccess()
        try wallet.finishDeployment()
        XCTAssertThrowsError(try wallet.abortDeployment())
    }

    func test_whenCreatingOwner_thenConfiguresIt() {
        let owner = Wallet.createOwner(address: "address")
        XCTAssertEqual(owner.address.value, "address")
    }

    func test_whenAddingDuplicateOwnerAddress_thenThrows() throws {
        try wallet.addOwner(Wallet.createOwner(address: "a"), kind: "a")
        XCTAssertThrowsError(try wallet.addOwner(Wallet.createOwner(address: "a"), kind: "b"))
    }

    func test_whenReplacingWithDuplicateOwner_thenThrows() throws {
        try wallet.addOwner(Wallet.createOwner(address: "a"), kind: "a")
        try wallet.addOwner(Wallet.createOwner(address: "b"), kind: "b")
        XCTAssertThrowsError(try wallet.replaceOwner(with: Wallet.createOwner(address: "a"), kind: "b"))
    }


}
