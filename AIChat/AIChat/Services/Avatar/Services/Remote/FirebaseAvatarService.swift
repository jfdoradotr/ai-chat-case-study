//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import FirebaseFirestore

struct FirebaseAvatarService: RemoteAvatarService {
  private static let featuredLimit = 50
  private static let popularLimit = 200
  private static let categoryLimit = 200
  private static let authorLimit = 200

  var collection: CollectionReference {
    Firestore.firestore().collection("avatars")
  }

  func createAvatar(_ avatar: AvatarModel) async throws {
    try collection.document(avatar.avatarId).setData(from: avatar, merge: true)
  }

  func getFeaturedAvatars() async throws -> [AvatarModel] {
    try await fetchAvatars(limit: Self.featuredLimit)
  }

  func getPopularAvatars() async throws -> [AvatarModel] {
    try await fetchAvatars(limit: Self.popularLimit)
  }

  func getAvatars(forCategory category: AvatarModel.Character) async throws -> [AvatarModel] {
    let snapshot = try await collection
      .whereField(AvatarModel.CodingKeys.character.rawValue, isEqualTo: category.rawValue)
      .order(by: AvatarModel.CodingKeys.dateCreated.rawValue, descending: true)
      .limit(to: Self.categoryLimit)
      .getDocuments()
    return snapshot.documents.compactMap { try? $0.data(as: AvatarModel.self) }
  }

  func getAvatars(forAuthorId authorId: String) async throws -> [AvatarModel] {
    let snapshot = try await collection
      .whereField(AvatarModel.CodingKeys.authorId.rawValue, isEqualTo: authorId)
      .order(by: AvatarModel.CodingKeys.dateCreated.rawValue, descending: true)
      .limit(to: Self.authorLimit)
      .getDocuments()
    return snapshot.documents.compactMap { try? $0.data(as: AvatarModel.self) }
  }

  private func fetchAvatars(limit: Int) async throws -> [AvatarModel] {
    let snapshot = try await collection
      .order(by: AvatarModel.CodingKeys.dateCreated.rawValue, descending: true)
      .limit(to: limit)
      .getDocuments()
    return snapshot.documents.compactMap { try? $0.data(as: AvatarModel.self) }
  }
}
