//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation
import OSLog

struct ConsoleLogService: LogService {
  private let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.aichat",
    category: "Analytics"
  )

  func identifyUser(userId: String, name: String?, email: String?) {
    let parameters: [String: Any] = [
      "userId": userId,
      "name": name ?? "nil",
      "email": email ?? "nil"
    ]
    log(level: .info, emoji: "👤", title: "Identify User", parameters: parameters)
  }

  func addUserProperties(dict: [String: Any]) {
    log(level: .info, emoji: "📋", title: "User Properties", parameters: dict)
  }

  func deleteUserProfile() {
    log(level: .default, emoji: "🗑️", title: "Delete User Profile", parameters: [:])
  }

  func trackEvent(event: any LoggableEvent) {
    log(level: .info, emoji: "📊", title: event.eventName, parameters: event.parameters)
  }

  func trackScreenEvent(event: any LoggableEvent) {
    log(level: .info, emoji: "📱", title: event.eventName, parameters: event.parameters)
  }

  private func log(level: OSLogType, emoji: String, title: String, parameters: [String: Any]) {
    var message = "\(emoji) \(title)"
    if !parameters.isEmpty {
      for key in parameters.keys.sorted() {
        let value = parameters[key] ?? ""
        message += "\n   \(key): \(value)"
      }
    }
    logger.log(level: level, "\(message, privacy: .public)")
  }
}
