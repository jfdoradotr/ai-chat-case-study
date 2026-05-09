//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct ConsoleLogService: LogService {
  func identifyUser(userId: String, name: String?, email: String?) {
    let parameters: [String: Any] = [
      "userId": userId,
      "name": name ?? "nil",
      "email": email ?? "nil"
    ]
    printEvent(emoji: "👤", title: "Identify User", parameters: parameters)
  }

  func addUserProperties(dict: [String: Any]) {
    printEvent(emoji: "📋", title: "User Properties", parameters: dict)
  }

  func deleteUserProfile() {
    printEvent(emoji: "🗑️", title: "Delete User Profile", parameters: nil)
  }

  func trackEvent(event: any LoggableEvent) {
    printEvent(emoji: "📊", title: event.eventName, parameters: event.parameters)
  }

  func trackScreenEvent(event: any LoggableEvent) {
    printEvent(emoji: "📱", title: event.eventName, parameters: event.parameters)
  }

  private func printEvent(emoji: String, title: String, parameters: [String: Any]?) {
    var output = "\(emoji) \(title)"
    if let parameters, !parameters.isEmpty {
      for key in parameters.keys.sorted() {
        let value = parameters[key] ?? ""
        output += "\n   \(key): \(value)"
      }
    }
    print(output)
  }
}
