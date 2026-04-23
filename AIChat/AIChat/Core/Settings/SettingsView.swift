//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(AppState.self) private var appState

  @State private var isPremium = false
  @State private var isAnonymousUser = true
  @State private var showCreateAccount = false

  var body: some View {
    List {
      Section {
        if isAnonymousUser {
          Button(
            "Save & back-up account",
            action: onCreateAccountPressed
          )
          .foregroundStyle(.primary)
        } else {
          Button(
            "Sign out",
            action: onSignOutPressed
          )
          .foregroundStyle(.primary)
          Button(
            "Delete account",
            role: .destructive,
            action: onDeleteAccountPressed
          )
        }
      } header: {
        Text("Account")
      }
      Section {
        HStack {
          Text("Account status: \(isPremium ? "PREMIUM" : "FREE")")
          Spacer()
          if isPremium {
            Button("MANAGE", action: onManagePressed)
              .font(.caption)
              .bold()
              .foregroundStyle(.white)
              .padding(.horizontal, 8)
              .padding(.vertical, 6)
              .background(Color.blue)
              .clipShape(.capsule)
          }
        }
      } header: {
        Text("Purchases")
      }
      Section {
        HStack {
          Text("Version")
          Spacer()
          Text(Bundle.main.appVersion)
        }
        HStack {
          Text("Build Number")
          Spacer()
          Text(Bundle.main.buildNumber)
        }
        Button(
          "Contact us",
          action: onContactUsPressed
        )
        .foregroundStyle(.blue)
      } header: {
        Text("Application")
      } footer: {
        VStack(alignment: .leading) {
          Text("Created by Swifty Journey.")
          if let url = URL(string: "https://swiftyjourney.com") {
            HStack(spacing: 0) {
              Text("Learn more at ")
              Link("www.swiftyjourney.com", destination: url)
            }
          }
        }
        .font(.footnote)
      }
    }
    .navigationTitle("Settings")
    .sheet(isPresented: $showCreateAccount) {
      Text("Create Account Screen")
    }
  }

  private func onSignOutPressed() {
    dismiss()
    Task {
      try? await Task.sleep(for: .seconds(0.3))
    }
    appState.updateViewState(showTabBar: false)
  }

  private func onCreateAccountPressed() {
    showCreateAccount = true
  }

  private func onDeleteAccountPressed() {}

  private func onManagePressed() {}

  private func onContactUsPressed() {}
}

#Preview {
  NavigationStack {
    SettingsView()
      .environment(AppState())
  }
}
