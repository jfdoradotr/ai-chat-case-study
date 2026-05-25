//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

struct FirebaseCrashlyticsLogService: LogService {
  func identifyUser(userId: String, name: String?, email: String?) {
    let crashlytics = Crashlytics.crashlytics()
    crashlytics.setUserID(userId)
    if let name {
      crashlytics.setCustomValue(name, forKey: "account_name")
    }
    if let email {
      crashlytics.setCustomValue(email, forKey: "account_email")
    }
  }

  func addUserProperties(dict: [String: Any]) {
    let crashlytics = Crashlytics.crashlytics()
    for (key, value) in dict {
      crashlytics.setCustomValue(value, forKey: key)
    }
  }

  func deleteUserProfile() {
    Crashlytics.crashlytics().setUserID("")
  }

  func trackEvent(event: any LoggableEvent) {
    Crashlytics.crashlytics().log(formatBreadcrumb(name: event.eventName, parameters: event.parameters))
  }

  func trackScreenEvent(event: any LoggableEvent) {
    Crashlytics.crashlytics().log(formatBreadcrumb(name: "screen:\(event.eventName)", parameters: event.parameters))
  }

  private func formatBreadcrumb(name: String, parameters: [String: Any]) -> String {
    guard !parameters.isEmpty else { return name }
    let pairs = parameters
      .map { "\($0.key)=\($0.value)" }
      .sorted()
      .joined(separator: " | ")
    return "\(name) | \(pairs)"
  }
}
