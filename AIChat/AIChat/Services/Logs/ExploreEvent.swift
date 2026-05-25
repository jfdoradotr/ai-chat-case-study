//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum ExploreEvent: LoggableEvent {
  case loadFeaturedStart
  case loadFeaturedSuccess(count: Int)
  case loadFeaturedFailure(error: any Error)
  case loadPopularStart
  case loadPopularSuccess(count: Int)
  case loadPopularFailure(error: any Error)
  case avatarPressed(avatar: AvatarModel)
  case categoryPressed(category: AvatarModel.Character)
  case tryAgainPressed
  case devSettingsPressed

  var eventName: String {
    switch self {
    case .loadFeaturedStart: return "Explore_LoadFeatured_Start"
    case .loadFeaturedSuccess: return "Explore_LoadFeatured_Success"
    case .loadFeaturedFailure: return "Explore_LoadFeatured_Failure"
    case .loadPopularStart: return "Explore_LoadPopular_Start"
    case .loadPopularSuccess: return "Explore_LoadPopular_Success"
    case .loadPopularFailure: return "Explore_LoadPopular_Failure"
    case .avatarPressed: return "Explore_Avatar_Pressed"
    case .categoryPressed: return "Explore_Category_Pressed"
    case .tryAgainPressed: return "Explore_TryAgain_Pressed"
    case .devSettingsPressed: return "Explore_DevSettings_Pressed"
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .loadFeaturedStart, .loadPopularStart, .tryAgainPressed, .devSettingsPressed:
      return [:]

    case .loadFeaturedSuccess(let count), .loadPopularSuccess(let count):
      return ["count": count, "is_empty": count == 0]

    case .avatarPressed(let avatar):
      return avatar.eventParameters

    case .categoryPressed(let category):
      return ["category": category.rawValue]

    case .loadFeaturedFailure(let error), .loadPopularFailure(let error):
      return ["error_type": String(describing: type(of: error)), "error": error.localizedDescription]
    }
  }
}
