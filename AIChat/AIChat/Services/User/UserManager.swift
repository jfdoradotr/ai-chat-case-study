//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol UserService: Sendable {
  func saveUser(user: UserModel) async throws
}

struct FirebaseUserService: UserService {
  var collection: CollectionReference {
    Firestore.firestore().collection("users")
  }

  func saveUser(user: UserModel) async throws {
    try collection.document(user.userId).setData(from: user, merge: true)
  }
}

@MainActor
@Observable
final class UserManager {
  private let service: any UserService
  private(set) var currentUser: UserModel?

  init(service: any UserService) {
    self.service = service
    self.currentUser = nil
  }

  func login(auth: UserAuthInfo, isNewUser: Bool) async throws {
    let creationVersion: String? = isNewUser ? Bundle.main.appVersion : nil
    let user = UserModel(auth: auth, creationVersion: creationVersion)
    try await service.saveUser(user: user)
  }
}
