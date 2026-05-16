//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum ScreenEvent: LoggableEvent {
  case welcome
  case onboardingIntroduction
  case onboardingColorSelection
  case onboardingCompleted
  case createAccount
  case chats
  case chat
  case explore
  case profile
  case settings
  case createAvatar
  case categoryList
  case devSettings

  var eventName: String {
    switch self {
    case .welcome: return "WelcomeView"
    case .onboardingIntroduction: return "OnboardingIntroductionView"
    case .onboardingColorSelection: return "OnboardingColorSelectionView"
    case .onboardingCompleted: return "OnboardingCompletedView"
    case .createAccount: return "CreateAccountView"
    case .chats: return "ChatsView"
    case .chat: return "ChatView"
    case .explore: return "ExploreView"
    case .profile: return "ProfileView"
    case .settings: return "SettingsView"
    case .createAvatar: return "CreateAvatarView"
    case .categoryList: return "CategoryListView"
    case .devSettings: return "DevSettingsView"
    }
  }

  var parameters: [String: Any] { [:] }
}
