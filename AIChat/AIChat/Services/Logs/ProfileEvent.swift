//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum ProfileEvent: LoggableEvent {
  case loadAvatarsStart
  case loadAvatarsSuccess(count: Int)
  case loadAvatarsFailure(error: any Error)
  case settingsPressed
  case newAvatarPressed
  case avatarPressed(avatar: AvatarModel)
  case deleteAvatarStart(avatar: AvatarModel)
  case deleteAvatarSuccess(avatar: AvatarModel)
  case deleteAvatarFailure(error: any Error)

  var eventName: String {
    switch self {
    case .loadAvatarsStart: return "Profile_LoadAvatars_Start"
    case .loadAvatarsSuccess: return "Profile_LoadAvatars_Success"
    case .loadAvatarsFailure: return "Profile_LoadAvatars_Failure"
    case .settingsPressed: return "Profile_Settings_Pressed"
    case .newAvatarPressed: return "Profile_NewAvatar_Pressed"
    case .avatarPressed: return "Profile_Avatar_Pressed"
    case .deleteAvatarStart: return "Profile_DeleteAvatar_Start"
    case .deleteAvatarSuccess: return "Profile_DeleteAvatar_Success"
    case .deleteAvatarFailure: return "Profile_DeleteAvatar_Failure"
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .loadAvatarsStart, .settingsPressed, .newAvatarPressed:
      return [:]

    case .loadAvatarsSuccess(let count):
      return ["count": count, "is_empty": count == 0]

    case .avatarPressed(let avatar), .deleteAvatarStart(let avatar), .deleteAvatarSuccess(let avatar):
      return avatar.eventParameters

    case .loadAvatarsFailure(let error), .deleteAvatarFailure(let error):
      return ["error_type": String(describing: type(of: error)), "error": error.localizedDescription]
    }
  }
}
