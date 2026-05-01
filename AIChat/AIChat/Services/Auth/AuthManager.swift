//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

@MainActor
@Observable
final class AuthManager {
  private let service: any AuthService
  private(set) var auth: UserAuthInfo?
  private var listener: (any NSObjectProtocol)?
  nonisolated private var task: Task<Void, any Error>?

  init(service: any AuthService) {
    self.service = service
    self.auth = service.getAuthenticatedUser()
    self.addAuthListener()
  }

  deinit {
    task?.cancel()
  }

  enum AuthError: LocalizedError {
    case notSignedIn
  }

  private func addAuthListener() {
    task = Task {
      for await value in service.addAuthenticatedUserListener(onListenerAttached: { listener in
        self.listener = listener
      }) {
        self.auth = value
        print("Auth listener success: \(value?.uid ?? "no uid")")
      }
    }
  }

  func getAuthId() throws -> String {
    guard let uid = auth?.uid else {
      throw AuthError.notSignedIn
    }
    return uid
  }

  func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
    try await service.signInAnonymously()
  }

  func signInGoogle() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
    try await service.signInGoogle()
  }

  func signOut() throws {
    try service.signOut()
    auth = nil
  }

  func deleteAccount() async throws {
    try await service.deleteAccount()
    auth = nil
  }
}
