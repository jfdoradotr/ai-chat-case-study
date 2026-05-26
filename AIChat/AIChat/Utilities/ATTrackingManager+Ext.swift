//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import AppTrackingTransparency

extension ATTrackingManager.AuthorizationStatus {
  /// A stable, human-readable value suitable for analytics parameters.
  var eventValue: String {
    switch self {
    case .notDetermined: return "not_determined"
    case .restricted: return "restricted"
    case .denied: return "denied"
    case .authorized: return "authorized"
    @unknown default: return "unknown"
    }
  }
}
