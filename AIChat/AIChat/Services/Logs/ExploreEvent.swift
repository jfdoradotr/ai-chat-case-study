//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum ExploreEvent: LoggableEvent {
  case loadFeaturedStart
  case loadFeaturedSuccess(count: Int)
  case loadFeaturedFailure(error: Error)
  case loadPopularStart
  case loadPopularSuccess(count: Int)
  case loadPopularFailure(error: Error)

  var eventName: String {
    switch self {
    case .loadFeaturedStart: return "Explore_LoadFeatured_Start"
    case .loadFeaturedSuccess: return "Explore_LoadFeatured_Success"
    case .loadFeaturedFailure: return "Explore_LoadFeatured_Failure"
    case .loadPopularStart: return "Explore_LoadPopular_Start"
    case .loadPopularSuccess: return "Explore_LoadPopular_Success"
    case .loadPopularFailure: return "Explore_LoadPopular_Failure"
    }
  }

  var parameters: [String: Any]? {
    switch self {
    case .loadFeaturedStart, .loadPopularStart:
      return nil
    case .loadFeaturedSuccess(let count), .loadPopularSuccess(let count):
      return ["count": count, "is_empty": count == 0]
    case .loadFeaturedFailure(let error), .loadPopularFailure(let error):
      return ["error_type": String(describing: type(of: error)), "error": error.localizedDescription]
    }
  }
}
