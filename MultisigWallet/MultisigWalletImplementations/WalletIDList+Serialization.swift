//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation
import MultisigWalletDomainModel

extension WalletIDList: DBSerializable {

    static let separator = ","

    init(serializedString: String) {
        self.init(serializedString.components(separatedBy: WalletIDList.separator).map { WalletID($0) })
    }

    public var serializedString: String {
        return map { $0.id }.joined(separator: WalletIDList.separator)
    }

}
