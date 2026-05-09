//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation
import Mixpanel

struct MixpanelLogService: LogService {
  func identifyUser(userId: String, name: String?, email: String?) {
    Mixpanel.mainInstance().identify(distinctId: userId)
    var properties: Properties = [:]
    if let name {
      properties["$name"] = name
    }
    if let email {
      properties["$email"] = email
    }
    if !properties.isEmpty {
      Mixpanel.mainInstance().people.set(properties: properties)
    }
  }

  func addUserProperties(dict: [String: Any]) {
    guard let properties = convert(dict) else { return }
    Mixpanel.mainInstance().people.set(properties: properties)
  }

  func deleteUserProfile() {
    Mixpanel.mainInstance().people.deleteUser()
    Mixpanel.mainInstance().reset()
  }

  func trackEvent(event: any LoggableEvent) {
    Mixpanel.mainInstance().track(event: event.eventName, properties: convert(event.parameters))
  }

  func trackScreenEvent(event: any LoggableEvent) {
    var properties = convert(event.parameters) ?? [:]
    properties["screen_name"] = event.eventName
    Mixpanel.mainInstance().track(event: "Screen Viewed", properties: properties)
  }

  private func convert(_ dict: [String: Any]?) -> Properties? {
    guard let dict else { return nil }
    var result: Properties = [:]
    for (key, value) in dict {
      if let value = value as? MixpanelType {
        result[key] = value
      } else {
        result[key] = String(describing: value)
      }
    }
    return result
  }
}
