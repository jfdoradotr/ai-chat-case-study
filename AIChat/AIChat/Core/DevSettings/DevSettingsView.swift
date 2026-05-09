//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct DevSettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(AuthManager.self) private var authManager
  @Environment(UserManager.self) private var userManager

  var body: some View {
    List {
      environmentSection
      userSection
      profileSection
      deviceSection
    }
    .navigationTitle("Developer Settings")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("Done") { dismiss() }
      }
    }
    .trackScreen(ScreenEvent.devSettings)
  }

  @ViewBuilder private var environmentSection: some View {
    Section("Environment") {
      LabeledContent("Configuration", value: BuildConfiguration.current.displayName)
    }
  }

  @ViewBuilder private var userSection: some View {
    Section("User") {
      if let auth = authManager.auth {
        LabeledContent("UID", value: auth.uid)
          .textSelection(.enabled)
        LabeledContent("Email", value: auth.email ?? "—")
        LabeledContent("Anonymous", value: auth.isAnonymous ? "Yes" : "No")
        LabeledContent("Created", value: formatted(auth.creationDate))
        LabeledContent("Last sign-in", value: formatted(auth.lastSignInDate))
      } else {
        Text("Not signed in")
          .foregroundStyle(.secondary)
      }
    }
  }

  @ViewBuilder private var profileSection: some View {
    Section("Profile") {
      if let user = userManager.currentUser {
        LabeledContent("Creation version", value: user.creationVersion ?? "—")
        LabeledContent("Onboarded", value: user.didCompleteOnboarding ? "Yes" : "No")
        LabeledContent("Profile color") {
          HStack(spacing: 8) {
            Circle()
              .fill(user.profileColor)
              .frame(width: 16, height: 16)
              .overlay(Circle().strokeBorder(.separator))
            Text(user.profileColorHex ?? "default")
              .foregroundStyle(.secondary)
              .monospaced()
          }
        }
      } else {
        Text("No user loaded")
          .foregroundStyle(.secondary)
      }
    }
  }

  @ViewBuilder private var deviceSection: some View {
    Section("Device") {
      LabeledContent("Model", value: UIDevice.current.model)
      LabeledContent("System", value: "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)")
      LabeledContent("App version", value: Bundle.main.appVersion)
      LabeledContent("Build", value: Bundle.main.buildNumber)
      LabeledContent("Locale", value: Locale.current.identifier)
      LabeledContent("Time zone", value: TimeZone.current.identifier)
    }
  }

  private func formatted(_ date: Date?) -> String {
    guard let date else { return "—" }
    return date.formatted(date: .abbreviated, time: .shortened)
  }
}
