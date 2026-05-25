//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum CreateAccountEvent: LoggableEvent {
  case signInGooglePressed(state: String)
  case signInGoogleStart(state: String)
  case signInGoogleSuccess(isNewUser: Bool, isAnonymous: Bool)
  case signInGoogleFailure(error: any Error)

  var eventName: String {
    switch self {
    case .signInGooglePressed: return "CreateAccount_SignInGoogle_Pressed"
    case .signInGoogleStart: return "CreateAccount_SignInGoogle_Start"
    case .signInGoogleSuccess: return "CreateAccount_SignInGoogle_Success"
    case .signInGoogleFailure: return "CreateAccount_SignInGoogle_Failure"
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .signInGooglePressed(let state), .signInGoogleStart(let state):
      return ["presentation_state": state]

    case let .signInGoogleSuccess(isNewUser, isAnonymous):
      return ["is_new_user": isNewUser, "is_anonymous": isAnonymous]

    case .signInGoogleFailure(let error):
      return ["error_type": String(describing: type(of: error)), "error": error.localizedDescription]
    }
  }
}
