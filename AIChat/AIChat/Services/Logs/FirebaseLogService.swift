//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation
import FirebaseAnalytics

struct FirebaseLogService: LogService {
  func identifyUser(userId: String, name: String?, email: String?) {
    Analytics.setUserID(userId)
    if let name {
      Analytics.setUserProperty(name, forName: "account_name")
    }
    if let email {
      Analytics.setUserProperty(email, forName: "account_email")
    }
  }

  func addUserProperties(dict: [String: Any]) {
    for (key, value) in dict {
      Analytics.setUserProperty(String(describing: value), forName: key)
    }
  }

  func deleteUserProfile() {
    Analytics.setUserID(nil)
    Analytics.resetAnalyticsData()
  }

  func trackEvent(event: any LoggableEvent) {
    Analytics.logEvent(event.eventName, parameters: event.parameters)
  }

  func trackScreenEvent(event: any LoggableEvent) {
    var parameters = event.parameters ?? [:]
    parameters[AnalyticsParameterScreenName] = event.eventName
    Analytics.logEvent(AnalyticsEventScreenView, parameters: parameters)
  }
}
