//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation
import FirebaseFirestore

@MainActor
@Observable
final class UserManager {
  private let remote: any RemoteUserService
  private let local: any LocalUserPersistence

  private(set) var currentUser: UserModel?
  private var currentUserListener: (any ListenerRegistration)?

  init(services: any UserServices) {
    self.remote = services.remote
    self.local = services.local
    self.currentUser = local.getCurrentUser()
    print("LOADED CURRENT USER ON LAUNCH: \(String(describing: currentUser?.userId))")
  }

  func login(auth: UserAuthInfo, isNewUser: Bool) async throws {
    if isNewUser {
      let user = UserModel(auth: auth, creationVersion: Bundle.main.appVersion)
      try await remote.saveUser(user: user)
    }
    addCurrentUserListener(userId: auth.uid)
  }

  private func addCurrentUserListener(userId: String) {
    currentUserListener?.remove()
    Task {
      do {
        for try await user in remote.streamUser(userId: userId, onListenerConfigured: { [weak self] listener in
          self?.currentUserListener = listener
        }) {
          self.currentUser = user
          self.saveCurrentUserLocally()
          print("successfully listened to user: \(user.userId)")
        }
      } catch {
        print("User listener error: \(error)")
      }
    }
  }

  private func saveCurrentUserLocally() {
    Task {
      do {
        try local.saveCurrentUser(user: currentUser)
        print("Success saved current user locally")
      } catch {
        print("Error saving current user locally: \(error)")
      }
    }
  }

  func markOnboardingCompleteForCurrentUser(profileColorHex: String) async throws {
    let uid = try currentUserId()
    try await remote.markOnboardingCompleted(userId: uid, profileColorHex: profileColorHex)
  }

  func signOut() {
    currentUserListener?.remove()
    currentUserListener = nil
    currentUser = nil
  }

  func deleteCurrentUser() async throws {
    let uid = try currentUserId()
    try await remote.deleteUser(userId: uid)
  }

  private func currentUserId() throws -> String {
    guard let uid = currentUser?.userId else {
      throw UserManagerError.noUserId
    }
    return uid
  }

  enum UserManagerError: LocalizedError {
    case noUserId
  }
}
