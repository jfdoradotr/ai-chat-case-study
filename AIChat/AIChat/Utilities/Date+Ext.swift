//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

extension Date {
  func adding(days: Int = 0, hours: Int = 0, minutes: Int = 0) -> Date {
    let total = TimeInterval(days) * 86400 + TimeInterval(hours) * 3600 + TimeInterval(minutes) * 60
    return addingTimeInterval(total)
  }

  func chatDayLabel(reference: Date = .now, calendar: Calendar = .current) -> String {
    if calendar.isDate(self, inSameDayAs: reference) { return "Today" }
    if calendar.isDateInYesterday(self) { return "Yesterday" }

    let referenceStart = calendar.startOfDay(for: reference)
    let selfStart = calendar.startOfDay(for: self)
    let daysAway = calendar.dateComponents([.day], from: selfStart, to: referenceStart).day ?? 0

    let formatter = DateFormatter()
    if (1...6).contains(daysAway) {
      formatter.dateFormat = "EEEE"
    } else {
      formatter.dateStyle = .medium
    }
    return formatter.string(from: self)
  }

  func chatHourLabel() -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: self)
  }
}
