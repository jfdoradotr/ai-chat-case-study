//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum WelcomeEvent: LoggableEvent {
  case getStartedPressed
  case signInPressed
  case termsOfServicePressed
  case privacyPolicyPressed

  var eventName: String {
    switch self {
    case .getStartedPressed: return "Welcome_GetStarted_Pressed"
    case .signInPressed: return "Welcome_SignIn_Pressed"
    case .termsOfServicePressed: return "Welcome_TermsOfService_Pressed"
    case .privacyPolicyPressed: return "Welcome_PrivacyPolicy_Pressed"
    }
  }

  var parameters: [String: Any] { [:] }
}
