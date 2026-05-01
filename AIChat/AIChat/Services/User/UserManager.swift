//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol LocalUserPersistence: Sendable {
  func getCurrentUser() -> UserModel?
  func saveCurrentUser(user: UserModel?) throws
}

struct FileManagerUserPersistence: LocalUserPersistence {
  private let userDocumentKey = "current_user"

  func getCurrentUser() -> UserModel? {
    try? FileManager.getDocument(key: userDocumentKey)
  }

  func saveCurrentUser(user: UserModel?) throws {
    try FileManager.saveDocument(key: userDocumentKey, value: user)
  }
}

struct MockUserPersistence: LocalUserPersistence {
  let currentUser: UserModel?

  init(user: UserModel? = nil) {
    self.currentUser = user
  }

  func getCurrentUser() -> UserModel? {
    currentUser
  }

  func saveCurrentUser(user: UserModel?) throws {}
}

protocol RemoteUserService: Sendable {
  func saveUser(user: UserModel) async throws
  func streamUser(
    userId: String,
    onListenerConfigured: (any ListenerRegistration) -> Void
  ) -> AsyncThrowingStream<UserModel, any Error>
  func deleteUser(userId: String) async throws
  func markOnboardingCompleted(userId: String, profileColorHex: String) async throws
}

struct MockUserService: RemoteUserService {
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

struct FirebaseUserService: RemoteUserService {
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

protocol UserServices {
  var remote: any RemoteUserService { get }
  var local: any LocalUserPersistence { get }
}

struct MockUserServices: UserServices {
  let remote: any RemoteUserService
  let local: any LocalUserPersistence

  init(user: UserModel? = nil) {
    self.remote = MockUserService(user: user)
    self.local = MockUserPersistence(user: user)
  }
}

struct ProductionUserServices: UserServices {
  let remote: any RemoteUserService = FirebaseUserService()
  let local: any LocalUserPersistence = FileManagerUserPersistence()
}

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
