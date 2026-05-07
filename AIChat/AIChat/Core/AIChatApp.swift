//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

enum BuildConfiguration {
  case mock, dev, prod

  static var current: BuildConfiguration {
    #if MOCK
    return .mock
    #elseif DEV
    return .dev
    #else
    return .prod
    #endif
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  var dependencies: Dependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  // swiftlint:disable discouraged_optional_collection
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()

    dependencies = Dependencies(config: .current)

    if let clientID = FirebaseApp.app()?.options.clientID {
      GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
    }
    return true
  }
  // swiftlint:enable discouraged_optional_collection
}

@main
struct AIChatApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self)
  var delegate

  var body: some Scene {
    WindowGroup {
      AppView()
        .environment(delegate.dependencies.userManager)
        .environment(delegate.dependencies.authManager)
        .environment(delegate.dependencies.aiManager)
        .environment(delegate.dependencies.avatarManager)
        .environment(delegate.dependencies.chatManager)
        .onOpenURL { url in
          _ = GIDSignIn.sharedInstance.handle(url)
        }
    }
  }
}

struct Dependencies {
  let authManager: AuthManager
  let userManager: UserManager
  let aiManager: AIManager
  let avatarManager: AvatarManager
  let chatManager: ChatManager

  init(config: BuildConfiguration) {
    switch config {
    case .mock:
      authManager = AuthManager(service: MockAuthService())
      userManager = UserManager(services: MockUserServices())
      aiManager = AIManager(service: MockAIService())
      avatarManager = AvatarManager(services: MockAvatarServices())
      chatManager = ChatManager(services: MockChatServices())
    case .dev:
      authManager = AuthManager(service: FirebaseAuthService())
      userManager = UserManager(services: ProductionUserServices())
      aiManager = AIManager(service: OpenAIService())
      avatarManager = AvatarManager(services: ProductionAvatarServices())
      chatManager = ChatManager(services: ProductionChatServices())
    case .prod:
      authManager = AuthManager(service: FirebaseAuthService())
      userManager = UserManager(services: ProductionUserServices())
      aiManager = AIManager(service: OpenAIService())
      avatarManager = AvatarManager(services: ProductionAvatarServices())
      chatManager = ChatManager(services: ProductionChatServices())
    }
  }
}
