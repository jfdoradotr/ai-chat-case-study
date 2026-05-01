//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import FirebaseFirestore

protocol RemoteUserService: Sendable {
  func saveUser(user: UserModel) async throws
  func streamUser(
    userId: String,
    onListenerConfigured: (any ListenerRegistration) -> Void
  ) -> AsyncThrowingStream<UserModel, any Error>
  func deleteUser(userId: String) async throws
  func markOnboardingCompleted(userId: String, profileColorHex: String) async throws
}
