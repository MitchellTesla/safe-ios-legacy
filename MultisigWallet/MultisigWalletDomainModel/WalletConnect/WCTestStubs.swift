//
//  Copyright © 2019 Gnosis Ltd. All rights reserved.
//

import Foundation
import MultisigWalletDomainModel

extension WCURL {

    static let testURL = WCURL(topic: "topic1",
                               version: "1",
                               bridgeURL: URL(string: "http://test.com")!,
                               key: "key")

}

extension WCClientMeta {

    static let testMeta = WCClientMeta(name: "name",
                                       description: "description",
                                       icons: [],
                                       url: URL(string: "http://test.com")!)

}

extension WCDAppInfo {

    static let testDAppInfo = WCDAppInfo(peerId: "peer1", peerMeta: WCClientMeta.testMeta)

}

extension WCWalletInfo {

    static let testWalletInfo = WCWalletInfo(approved: true,
                                             accounts: [],
                                             chainId: 1,
                                             peerId: "peer1",
                                             peerMeta: WCClientMeta.testMeta)

}

extension WCSession {

    static let testSession = WCSession(url: MultisigWalletDomainModel.WCURL.testURL,
                                       dAppInfo: WCDAppInfo.testDAppInfo,
                                       walletInfo: WCWalletInfo.testWalletInfo,
                                       status: .connected)

}

extension WCMessage {

    static let testMessage = WCMessage(payload: "", url: WCURL.testURL)

}

extension WCSendTransactionRequest {

    static let testRequest = WCSendTransactionRequest(from: "0xCF4140193531B8b2d6864cA7486Ff2e18da5cA95",
                                                      to: "0xCF4140193531B8b2d6864cA7486Ff2e18da5cA95",
                                                      gasLimit: "0x5208",
                                                      gasPrice: "0x3b9aca00",
                                                      value: "0x00",
                                                      data: "0x",
                                                      nonce: "0x00")
}
