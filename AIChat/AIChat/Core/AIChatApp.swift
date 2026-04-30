//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  // swiftlint:disable discouraged_optional_collection
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()
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
    }
  }
}
