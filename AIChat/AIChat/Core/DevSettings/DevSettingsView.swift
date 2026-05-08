//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct DevSettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(AuthManager.self) private var authManager

  var body: some View {
    List {
      userSection
    }
    .navigationTitle("Developer Settings")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("Done") { dismiss() }
      }
    }
  }

  @ViewBuilder
  private var userSection: some View {
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

  private func formatted(_ date: Date?) -> String {
    guard let date else { return "—" }
    return date.formatted(date: .abbreviated, time: .shortened)
  }
}
