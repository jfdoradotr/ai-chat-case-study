//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

extension Date {
  func adding(days: Int = 0, hours: Int = 0, minutes: Int = 0) -> Date {
    let total = TimeInterval(days) * 86400 + TimeInterval(hours) * 3600 + TimeInterval(minutes) * 60
    return addingTimeInterval(total)
  }
}
