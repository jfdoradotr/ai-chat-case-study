//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum CreateAvatarEvent: LoggableEvent {
  case backButtonPressed
  case generateImageStart(character: AvatarModel.Character, action: AvatarModel.Action, location: AvatarModel.Location)
  case generateImageSuccess(character: AvatarModel.Character, action: AvatarModel.Action, location: AvatarModel.Location)
  case generateImageFailure(error: any Error)
  case saveAvatarStart
  case saveAvatarSuccess
  case saveAvatarFailure(error: any Error)

  var eventName: String {
    switch self {
    case .backButtonPressed: return "CreateAvatar_BackButton_Pressed"
    case .generateImageStart: return "CreateAvatar_GenerateImage_Start"
    case .generateImageSuccess: return "CreateAvatar_GenerateImage_Success"
    case .generateImageFailure: return "CreateAvatar_GenerateImage_Failure"
    case .saveAvatarStart: return "CreateAvatar_SaveAvatar_Start"
    case .saveAvatarSuccess: return "CreateAvatar_SaveAvatar_Success"
    case .saveAvatarFailure: return "CreateAvatar_SaveAvatar_Failure"
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .backButtonPressed, .saveAvatarStart, .saveAvatarSuccess:
      return [:]

    case .generateImageStart(let character, let action, let location),
      .generateImageSuccess(let character, let action, let location):
      return [
        "avatar_character": character.rawValue,
        "avatar_action": action.rawValue,
        "avatar_location": location.rawValue
      ]

    case .generateImageFailure(let error), .saveAvatarFailure(let error):
      return ["error_type": String(describing: type(of: error)), "error": error.localizedDescription]
    }
  }
}
