//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import FirebaseFirestore

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
