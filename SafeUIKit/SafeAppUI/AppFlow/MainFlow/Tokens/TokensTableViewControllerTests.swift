//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import XCTest
@testable import SafeAppUI
import MultisigWalletApplication
import CommonTestSupport

class TokensTableViewControllerTests: SafeTestCase {

    let controller = TokensTableViewController()

    override func setUp() {
        super.setUp()
        walletService.visibleTokensOutput = [TokenData.eth, TokenData.gno, TokenData.mgn]
    }

    func test_whenCreated_thenLoadsData() {
        createWindow(controller)
        controller.notify()
        delay()
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: 0), 3)
        let firstCell = cell(at: 0)
        let secondCell = cell(at: 1)
        let thirdCell = cell(at: 2)
        XCTAssertEqual(firstCell.tokenCodeLabel.text, "ETH")
        XCTAssertEqual(firstCell.tokenBalanceLabel.text?.replacingOccurrences(of: ",", with: "."), "0.01")
        XCTAssertEqual(secondCell.tokenCodeLabel.text, "GNO")
        XCTAssertEqual(secondCell.tokenBalanceLabel.text?.replacingOccurrences(of: ",", with: "."), "1")
        XCTAssertEqual(thirdCell.tokenCodeLabel.text, "MGN")
        XCTAssertEqual(thirdCell.tokenBalanceLabel.text, "--")
    }

    func test_whenCreated_thenSyncs() {
        createWindow(controller)
        XCTAssertTrue(walletService.didSync)
    }

    func test_whenSelectingRow_thenDeselectsIt() {
        createWindow(controller)
        controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNil(controller.tableView.indexPathForSelectedRow)
    }

    func test_whenCreatingFooter_thenDequeuesIt() {
        createWindow(controller)
        let footer = controller.tableView(controller.tableView, viewForFooterInSection: 0)
        XCTAssertTrue(footer is AddTokenFooterView)
    }

}

private extension TokensTableViewControllerTests {

    func cell(at row: Int) -> TokenBalanceTableViewCell {
        return controller.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! TokenBalanceTableViewCell
    }

}
