//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class AvatarEntity {
  @Attribute(.unique)
  var avatarId: String
  var name: String?
  var characterRaw: String?
  var actionRaw: String?
  var locationRaw: String?
  var authorId: String?
  var dateCreated: Date?
  var imageURLString: String?
  var dateAdded: Date

  init(from avatar: AvatarModel) {
    self.avatarId = avatar.avatarId
    self.name = avatar.name
    self.characterRaw = avatar.character?.rawValue
    self.actionRaw = avatar.action?.rawValue
    self.locationRaw = avatar.location?.rawValue
    self.authorId = avatar.authorId
    self.dateCreated = avatar.dateCreated
    self.imageURLString = avatar.imageURL?.absoluteString
    self.dateAdded = .now
  }

  func toModel() -> AvatarModel {
    AvatarModel(
      avatarId: avatarId,
      name: name,
      character: characterRaw.flatMap(AvatarModel.Character.init(rawValue:)),
      action: actionRaw.flatMap(AvatarModel.Action.init(rawValue:)),
      location: locationRaw.flatMap(AvatarModel.Location.init(rawValue:)),
      authorId: authorId,
      dateCreated: dateCreated,
      imageURL: imageURLString.flatMap(URL.init(string:))
    )
  }
}
