//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum OnboardingEvent: LoggableEvent {
  case introContinuePressed
  case colorSelected(hex: String)
  case colorContinuePressed(hex: String)
  case finishPressed
  case completeOnboardingStart
  case completeOnboardingSuccess(hex: String)
  case completeOnboardingFailure(error: any Error)

  var eventName: String {
    switch self {
    case .introContinuePressed: return "OnboardingIntro_Continue_Pressed"
    case .colorSelected: return "OnboardingColor_Color_Selected"
    case .colorContinuePressed: return "OnboardingColor_Continue_Pressed"
    case .finishPressed: return "OnboardingCompleted_Finish_Pressed"
    case .completeOnboardingStart: return "OnboardingCompleted_Complete_Start"
    case .completeOnboardingSuccess: return "OnboardingCompleted_Complete_Success"
    case .completeOnboardingFailure: return "OnboardingCompleted_Complete_Failure"
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .introContinuePressed, .finishPressed, .completeOnboardingStart:
      return [:]

    case .colorSelected(let hex), .colorContinuePressed(let hex), .completeOnboardingSuccess(let hex):
      return ["profile_color_hex": hex]

    case .completeOnboardingFailure(let error):
      return ["error_type": String(describing: type(of: error)), "error": error.localizedDescription]
    }
  }
}
