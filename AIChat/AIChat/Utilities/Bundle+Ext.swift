//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "–"
    }

    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "–"
    }
}
