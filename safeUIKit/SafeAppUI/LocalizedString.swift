//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation

private class BundleMarker {}

extension Bundle {
    static let SafeAppUI = Bundle(for: BundleMarker.self)
}

func LocalizedString(_ key: String, comment: String) -> String {
    return NSLocalizedString(key, bundle: Bundle.SafeAppUI, comment: comment)
}
