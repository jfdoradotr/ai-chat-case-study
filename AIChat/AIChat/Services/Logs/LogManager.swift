//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

@MainActor
@Observable
final class LogManager {
  private let services: [any LogService]

  init(services: [any LogService]) {
    self.services = services
  }

  func identifyUser(userId: String, name: String?, email: String?) {
    for service in services {
      service.identifyUser(userId: userId, name: name, email: email)
    }
  }

  func addUserProperties(dict: [String: Any]) {
    for service in services {
      service.addUserProperties(dict: dict)
    }
  }

  func deleteUserProfile() {
    for service in services {
      service.deleteUserProfile()
    }
  }

  func trackEvent(event: any LoggableEvent) {
    for service in services {
      service.trackEvent(event: event)
    }
  }

  func trackScreenEvent(event: any LoggableEvent) {
    for service in services {
      service.trackScreenEvent(event: event)
    }
  }
}
