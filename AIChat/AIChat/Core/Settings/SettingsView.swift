//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(AuthManager.self) private var authManager
  @Environment(AppState.self) private var appState

  @State private var isPremium = false
  @State private var showCreateAccount = false
  @State private var pendingConfirmation: AuthAction?
  @State private var errorMessage: String?

  private enum AuthAction: Identifiable {
    case signOut
    case deleteAccount

    var id: Self { self }

    var title: String {
      switch self {
      case .signOut: return "Sign out?"
      case .deleteAccount: return "Delete account?"
      }
    }

    var message: String {
      switch self {
      case .signOut:
        return "You'll need to sign in again to access your account."

      case .deleteAccount:
        return "This action is permanent. All your data will be deleted and cannot be recovered."
      }
    }

    var confirmLabel: String {
      switch self {
      case .signOut: return "Sign out"
      case .deleteAccount: return "Delete"
      }
    }

    var isDestructive: Bool {
      switch self {
      case .signOut: return false
      case .deleteAccount: return true
      }
    }
  }

  var body: some View {
    List {
      accountSection
      purchaseSection
      applicationSection
    }
    .navigationTitle("Settings")
    .sheet(isPresented: $showCreateAccount) {
      CreateAccountView(presentationState: .createAccount)
        .presentationDetents([.medium])
    }
    .alert(
      pendingConfirmation?.title ?? "",
      isPresented: Binding(
        get: { pendingConfirmation != nil },
        set: { if !$0 { pendingConfirmation = nil } }
      ),
      presenting: pendingConfirmation
    ) { action in
      Button(action.confirmLabel, role: action.isDestructive ? .destructive : nil) {
        perform(action)
      }
      Button("Cancel", role: .cancel) {}
    } message: { action in
      Text(action.message)
    }
    .alert(
      "Something went wrong",
      isPresented: Binding(
        get: { errorMessage != nil },
        set: { if !$0 { errorMessage = nil } }
      ),
      presenting: errorMessage
    ) { _ in
      Button("OK", role: .cancel) {}
    } message: { message in
      Text(message)
    }
  }

  private var isAnonymousUser: Bool {
    authManager.auth?.isAnonymous == true
  }

  private var accountSection: some View {
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
  }

  private var purchaseSection: some View {
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
  }

  private var applicationSection: some View {
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

  private func onSignOutPressed() {
    pendingConfirmation = .signOut
  }

  private func onCreateAccountPressed() {
    showCreateAccount = true
  }

  private func onDeleteAccountPressed() {
    pendingConfirmation = .deleteAccount
  }

  private func perform(_ action: AuthAction) {
    switch action {
    case .signOut:
      performAuthAction(label: "Sign out") {
        try authManager.signOut()
      }

    case .deleteAccount:
      performAuthAction(label: "Delete account") {
        try await authManager.deleteAccount()
      }
    }
  }

  private func performAuthAction(
    label: String,
    action: @escaping () async throws -> Void
  ) {
    Task {
      do {
        try await action()
        dismiss()
        try? await Task.sleep(for: .seconds(0.3))
        appState.updateViewState(showTabBar: false)
        _ = try? await authManager.signInAnonymously()
      } catch {
        errorMessage = "\(label) failed: \(error.localizedDescription)"
      }
    }
  }

  private func onManagePressed() {}

  private func onContactUsPressed() {}
}

#Preview("No Auth") {
  NavigationStack {
    SettingsView()
      .environment(AuthManager(service: MockAuthService()))
      .environment(AppState())
  }
}

#Preview("Anonymous") {
  NavigationStack {
    SettingsView()
      .environment(AuthManager(service: MockAuthService(user: .anonymousPreview)))
      .environment(AppState())
  }
}

#Preview("Non-Anonymous") {
  NavigationStack {
    SettingsView()
      .environment(AuthManager(service: MockAuthService(user: .preview)))
      .environment(AppState())
  }
}
