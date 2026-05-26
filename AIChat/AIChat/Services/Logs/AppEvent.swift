//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum AppEvent: LoggableEvent {
  case checkUserStatusStarted
  case existingUserLoginSuccess(isAnonymous: Bool)
  case existingUserLoginFailure(error: any Error)
  case anonymousSignInSuccess(isNewUser: Bool)
  case anonymousSignInFailure(error: any Error)
  case attPromptResult(status: String)

  var eventName: String {
    switch self {
    case .checkUserStatusStarted: return "App_CheckUserStatus_Started"
    case .existingUserLoginSuccess: return "App_ExistingUser_LoginSuccess"
    case .existingUserLoginFailure: return "App_ExistingUser_LoginFailure"
    case .anonymousSignInSuccess: return "App_AnonymousSignIn_Success"
    case .anonymousSignInFailure: return "App_AnonymousSignIn_Failure"
    case .attPromptResult: return "App_ATTPrompt_Result"
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .checkUserStatusStarted:
      return [:]

    case .attPromptResult(let status):
      return ["att_status": status]

    case .existingUserLoginSuccess(let isAnonymous):
      return ["is_anonymous": isAnonymous]

    case .existingUserLoginFailure(let error):
      return ["error_type": String(describing: type(of: error)), "error": error.localizedDescription]

    case .anonymousSignInSuccess(let isNewUser):
      return ["is_new_user": isNewUser]

    case .anonymousSignInFailure(let error):
      return ["error_type": String(describing: type(of: error)), "error": error.localizedDescription]
    }
  }
}
