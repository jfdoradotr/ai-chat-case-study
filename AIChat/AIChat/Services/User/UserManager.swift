//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol UserService: Sendable {
  func saveUser(user: UserModel) async throws
  func streamUser(
    userId: String,
    onListenerConfigured: (any ListenerRegistration) -> Void
  ) -> AsyncThrowingStream<UserModel, any Error>
  func deleteUser(userId: String) async throws
  func markOnboardingCompleted(userId: String, profileColorHex: String) async throws
}

struct MockUserService: UserService {
  let currentUser: UserModel?

  init(user: UserModel? = nil) {
    self.currentUser = user
  }

  func saveUser(user: UserModel) async throws {}

  func streamUser(
    userId: String,
    onListenerConfigured: (any ListenerRegistration) -> Void
  ) -> AsyncThrowingStream<UserModel, any Error> {
    AsyncThrowingStream { continuation in
      if let currentUser {
        continuation.yield(currentUser)
      }
    }
  }

  func deleteUser(userId: String) async throws {}

  func markOnboardingCompleted(userId: String, profileColorHex: String) async throws {}
}

struct FirebaseUserService: UserService {
  var collection: CollectionReference {
    Firestore.firestore().collection("users")
  }

  func saveUser(user: UserModel) async throws {
    try collection.document(user.userId).setData(from: user, merge: true)
  }

  func markOnboardingCompleted(userId: String, profileColorHex: String) async throws {
    try await collection.document(userId).updateData([
      UserModel.CodingKeys.didCompleteOnboarding.rawValue: true,
      UserModel.CodingKeys.profileColorHex.rawValue: profileColorHex
    ])
  }

  func streamUser(
    userId: String,
    onListenerConfigured: (any ListenerRegistration) -> Void
  ) -> AsyncThrowingStream<UserModel, any Error> {
    AsyncThrowingStream { continuation in
      let listener = collection.document(userId).addSnapshotListener { snapshot, error in
        if let error {
          continuation.finish(throwing: error)
          return
        }
        guard let snapshot, snapshot.exists else { return }
        do {
          let user = try snapshot.data(as: UserModel.self)
          continuation.yield(user)
        } catch {
          continuation.finish(throwing: error)
        }
      }
      onListenerConfigured(listener)
      continuation.onTermination = { _ in
        listener.remove()
      }
    }
  }

  func deleteUser(userId: String) async throws {
    try await collection.document(userId).delete()
  }
}

@MainActor
@Observable
final class UserManager {
  private let service: any UserService
  private(set) var currentUser: UserModel?
  private var currentUserListener: (any ListenerRegistration)?

  init(service: any UserService) {
    self.service = service
    self.currentUser = nil
  }

  func login(auth: UserAuthInfo, isNewUser: Bool) async throws {
    if isNewUser {
      let user = UserModel(auth: auth, creationVersion: Bundle.main.appVersion)
      try await service.saveUser(user: user)
    }
    addCurrentUserListener(userId: auth.uid)
  }

  private func addCurrentUserListener(userId: String) {
    currentUserListener?.remove()
    Task {
      do {
        for try await user in service.streamUser(userId: userId, onListenerConfigured: { [weak self] listener in
          self?.currentUserListener = listener
        }) {
          self.currentUser = user
          print("successfully listened to user: \(user.userId)")
        }
      } catch {
        print("User listener error: \(error)")
      }
    }
  }

  func markOnboardingCompleteForCurrentUser(profileColorHex: String) async throws {
    let uid = try currentUserId()
    try await service.markOnboardingCompleted(userId: uid, profileColorHex: profileColorHex)
  }

  func signOut() {
    currentUserListener?.remove()
    currentUserListener = nil
    currentUser = nil
  }

  func deleteCurrentUser() async throws {
    let uid = try currentUserId()
    try await service.deleteUser(userId: uid)
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
