//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum UserManagerEvent: LoggableEvent {
  case newUserCreated(user: UserModel)
  case remoteUserStreamFailure(error: any Error)
  case saveUserLocalFailure(error: any Error)

  var eventName: String {
    switch self {
    case .newUserCreated: return "UserManager_NewUser_Created"
    case .remoteUserStreamFailure: return "UserManager_RemoteUserStream_Failure"
    case .saveUserLocalFailure: return "UserManager_SaveUserLocal_Failure"
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .newUserCreated(let user):
      return user.eventParameters

    case .remoteUserStreamFailure(let error), .saveUserLocalFailure(let error):
      return ["error_type": String(describing: type(of: error)), "error": error.localizedDescription]
    }
  }
}
