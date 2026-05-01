//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct AppView: View {
  @Environment(AuthManager.self) private var authManager
  @Environment(UserManager.self) private var userManager
  @State private var appState = AppState()

  var body: some View {
    AppViewBuilder(
      showTabBar: appState.showTabBar,
      tabBarView: {
        TabBarView()
      },
      onboardingView: {
        NavigationStack {
          WelcomeView()
        }
      }
    )
    .environment(appState)
    .task {
      await checkUserStatus()
    }
  }

  private func checkUserStatus() async {
    if let user = authManager.auth {
      // user authenticated
      print("User already authenticated: \(user.uid)")
      do {
        try await userManager.login(auth: user, isNewUser: false)
      } catch {
        print("Failed to log in to auth for existing user: \(error)")
        try? await Task.sleep(for: .seconds(5))
        await checkUserStatus()
      }
    } else {
      // user is not authenticated
      do {
        let result = try await authManager.signInAnonymously()
        print("Sign in anonymous success: \(result.user.uid)")
        try await userManager.login(auth: result.user, isNewUser: result.isNewUser)
      } catch {
        print("Failed to sign in anonymously and log in: \(error)")
        try? await Task.sleep(for: .seconds(5))
        await checkUserStatus()
      }
    }
  }
}

#Preview {
  AppView()
    .environment(UserManager(service: MockUserService(user: .preview)))
    .environment(AuthManager(service: MockAuthService(user: .preview)))
}
