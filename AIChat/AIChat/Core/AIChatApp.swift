//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import Mixpanel

enum BuildConfiguration {
  case mock, dev, prod

  static var current: Self {
    #if MOCK
    return .mock
    #elseif DEV
    return .dev
    #else
    return .prod
    #endif
  }

  var firebasePlistName: String? {
    switch self {
    case .mock: return nil
    case .dev: return "GoogleService-Info-Dev"
    case .prod: return "GoogleService-Info-Prod"
    }
  }

  var mixpanelToken: String? {
    switch self {
    case .mock: return nil
    case .dev: return Keys.Mixpanel.devToken
    case .prod: return Keys.Mixpanel.prodToken
    }
  }

  var displayName: String {
    switch self {
    case .mock: return "Mock"
    case .dev: return "Development"
    case .prod: return "Production"
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  var dependencies: Dependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  // swiftlint:disable discouraged_optional_collection
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    let config = BuildConfiguration.current
    configureFirebase(for: config)
    configureMixpanel(for: config)
    dependencies = Dependencies(config: config)
    return true
  }
  // swiftlint:enable discouraged_optional_collection

  private func configureMixpanel(for config: BuildConfiguration) {
    guard let token = config.mixpanelToken else { return }
    Mixpanel.initialize(token: token, trackAutomaticEvents: false)
    if config == .dev {
      Mixpanel.mainInstance().flushInterval = 1
      Mixpanel.mainInstance().loggingEnabled = true
    }
  }

  private func configureFirebase(for config: BuildConfiguration) {
    guard let plistName = config.firebasePlistName else { return }
    guard
      let path = Bundle.main.path(forResource: plistName, ofType: "plist"),
      let options = FirebaseOptions(contentsOfFile: path)
    else {
      assertionFailure("Missing Firebase plist: \(plistName).plist")
      return
    }
    FirebaseApp.configure(options: options)

    if let clientID = FirebaseApp.app()?.options.clientID {
      GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
    }
  }
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
        .environment(delegate.dependencies.logManager)
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
  let logManager: LogManager

  init(config: BuildConfiguration) {
    switch config {
    case .mock:
      let logManager = LogManager(services: [ConsoleLogService()])
      self.logManager = logManager
      authManager = AuthManager(service: MockAuthService(user: .preview))
      userManager = UserManager(services: MockUserServices(user: .preview), logManager: logManager)
      aiManager = AIManager(service: MockAIService())
      avatarManager = AvatarManager(services: MockAvatarServices())
      chatManager = ChatManager(services: MockChatServices())

    case .dev:
      let logManager = LogManager(services: [
        ConsoleLogService(),
        FirebaseLogService(),
        FirebaseCrashlyticsLogService(),
        MixpanelLogService()
      ])
      self.logManager = logManager
      authManager = AuthManager(service: FirebaseAuthService())
      userManager = UserManager(services: ProductionUserServices(), logManager: logManager)
      aiManager = AIManager(service: OpenAIService())
      avatarManager = AvatarManager(services: ProductionAvatarServices())
      chatManager = ChatManager(services: ProductionChatServices())

    case .prod:
      let logManager = LogManager(services: [
        FirebaseLogService(),
        FirebaseCrashlyticsLogService(),
        MixpanelLogService()
      ])
      self.logManager = logManager
      authManager = AuthManager(service: FirebaseAuthService())
      userManager = UserManager(services: ProductionUserServices(), logManager: logManager)
      aiManager = AIManager(service: OpenAIService())
      avatarManager = AvatarManager(services: ProductionAvatarServices())
      chatManager = ChatManager(services: ProductionChatServices())
    }
  }
}
