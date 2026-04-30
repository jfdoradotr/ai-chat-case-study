//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct AppView: View {
  @Environment(\.authService) private var authService
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
    if let user = authService.getAuthenticatedUser() {
      // user authenticated
      print("User already authenticated: \(user.uid)")
    } else {
      // user is not authenticated
      do {
        let result = try await authService.signInAnonymously()
        print("Sign in anonymous success: \(result.user.uid)")
      } catch {
        print(error)
      }
    }
  }
}

#Preview {
  AppView()
}
