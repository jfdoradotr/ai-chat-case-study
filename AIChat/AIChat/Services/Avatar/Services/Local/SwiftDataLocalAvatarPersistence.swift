//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataLocalAvatarPersistence: LocalAvatarPersistence {
  private let container: ModelContainer
  private var context: ModelContext { container.mainContext }

  init() {
    do {
      self.container = try ModelContainer(for: AvatarEntity.self)
    } catch {
      fatalError("Failed to create ModelContainer for AvatarEntity: \(error)")
    }
  }

  func addRecentAvatar(_ avatar: AvatarModel) async throws {
    let id = avatar.avatarId
    let descriptor = FetchDescriptor<AvatarEntity>(
      predicate: #Predicate { $0.avatarId == id }
    )
    if let existing = try context.fetch(descriptor).first {
      context.delete(existing)
    }
    context.insert(AvatarEntity(from: avatar))
    try context.save()
  }

  func getRecentAvatars() async throws -> [AvatarModel] {
    let descriptor = FetchDescriptor<AvatarEntity>(
      sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
    )
    let entities = try context.fetch(descriptor)
    return entities.map { $0.toModel() }
  }
}
