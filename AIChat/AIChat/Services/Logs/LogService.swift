//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

protocol LogService: Sendable {
  func identifyUser(userId: String, name: String?, email: String?)
  func addUserProperties(dict: [String: Any])
  func deleteUserProfile()
  func trackEvent(event: any LoggableEvent)
  func trackScreenEvent(event: any LoggableEvent)
}

protocol LoggableEvent {
  var eventName: String { get }
  var parameters: [String: Any]? { get }
}
