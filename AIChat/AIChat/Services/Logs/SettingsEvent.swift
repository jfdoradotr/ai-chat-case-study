//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum SettingsEvent: LoggableEvent {
  case createAccountPressed
  case signOutPressed
  case signOutStart
  case signOutSuccess
  case signOutFailure(error: any Error)
  case deleteAccountPressed
  case deleteAccountStart
  case deleteAccountSuccess
  case deleteAccountFailure(error: any Error)
  case signInAnonymousStart
  case signInAnonymousSuccess
  case signInAnonymousFailure(error: any Error)
  case managePressed
  case contactUsPressed

  var eventName: String {
    switch self {
    case .createAccountPressed: return "Settings_CreateAccount_Pressed"
    case .signOutPressed: return "Settings_SignOut_Pressed"
    case .signOutStart: return "Settings_SignOut_Start"
    case .signOutSuccess: return "Settings_SignOut_Success"
    case .signOutFailure: return "Settings_SignOut_Failure"
    case .deleteAccountPressed: return "Settings_DeleteAccount_Pressed"
    case .deleteAccountStart: return "Settings_DeleteAccount_Start"
    case .deleteAccountSuccess: return "Settings_DeleteAccount_Success"
    case .deleteAccountFailure: return "Settings_DeleteAccount_Failure"
    case .signInAnonymousStart: return "Settings_SignInAnonymous_Start"
    case .signInAnonymousSuccess: return "Settings_SignInAnonymous_Success"
    case .signInAnonymousFailure: return "Settings_SignInAnonymous_Failure"
    case .managePressed: return "Settings_Manage_Pressed"
    case .contactUsPressed: return "Settings_ContactUs_Pressed"
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .signOutFailure(let error),
      .deleteAccountFailure(let error),
      .signInAnonymousFailure(let error):
      return ["error_type": String(describing: type(of: error)), "error": error.localizedDescription]

    default:
      return [:]
    }
  }
}
