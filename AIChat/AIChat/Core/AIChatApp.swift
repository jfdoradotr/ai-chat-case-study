//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  var dependencies: Dependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  // swiftlint:disable discouraged_optional_collection
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()

    dependencies = Dependencies()

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

  init() {
    authManager = AuthManager(service: FirebaseAuthService())
    userManager = UserManager(services: ProductionUserServices())
    aiManager = AIManager(service: OpenAIService())
    avatarManager = AvatarManager(services: ProductionAvatarServices())
  }
}
