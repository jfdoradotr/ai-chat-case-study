//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  // swiftlint:disable discouraged_optional_collection
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()
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
      EnvironmentBuilderView {
        AppView()
      }
    }
  }
}

struct EnvironmentBuilderView<Content: View>: View {
  @ViewBuilder var content: () -> Content

  var body: some View {
    content()
      .environment(\.authService, FirebaseAuthService())
      .onOpenURL { url in
        _ = GIDSignIn.sharedInstance.handle(url)
      }
  }
}
