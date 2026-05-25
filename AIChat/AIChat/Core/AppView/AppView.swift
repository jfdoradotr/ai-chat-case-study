//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct AppView: View {
  @Environment(AuthManager.self) private var authManager
  @Environment(UserManager.self) private var userManager
  @Environment(LogManager.self) private var logManager
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
    logManager.trackEvent(event: AppEvent.checkUserStatusStarted)
    if let user = authManager.auth {
      // user authenticated
      print("User already authenticated: \(user.uid)")
      do {
        try await userManager.login(auth: user, isNewUser: false)
        logManager.identifyUser(userId: user.uid, name: nil, email: user.email)
        logManager.trackEvent(event: AppEvent.existingUserLoginSuccess(isAnonymous: user.isAnonymous))
      } catch {
        print("Failed to log in to auth for existing user: \(error)")
        logManager.trackEvent(event: AppEvent.existingUserLoginFailure(error: error))
        try? await Task.sleep(for: .seconds(5))
        await checkUserStatus()
      }
    } else {
      // user is not authenticated
      do {
        let result = try await authManager.signInAnonymously()
        print("Sign in anonymous success: \(result.user.uid)")
        try await userManager.login(auth: result.user, isNewUser: result.isNewUser)
        logManager.identifyUser(userId: result.user.uid, name: nil, email: result.user.email)
        logManager.trackEvent(event: AppEvent.anonymousSignInSuccess(isNewUser: result.isNewUser))
      } catch {
        print("Failed to sign in anonymously and log in: \(error)")
        logManager.trackEvent(event: AppEvent.anonymousSignInFailure(error: error))
        try? await Task.sleep(for: .seconds(5))
        await checkUserStatus()
      }
    }
  }
}

#Preview {
  AppView()
    .previewEnvironment()
}
