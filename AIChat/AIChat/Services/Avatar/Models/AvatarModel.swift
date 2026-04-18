//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct AvatarModel: Identifiable {
  let avatarId: String
  let name: String?
  let character: Character?
  let action: Action?
  let location: Location?
  let authorId: String?
  let dateCreated: Date?

  var id: String { avatarId }

  var description: String {
    var components: [String] = []
    if let character { components.append(character.phrase) }
    if let action { components.append("that is \(action.rawValue)") }
    if let location { components.append(location.phrase) }
    return components.joined(separator: " ")
  }

  init(
    avatarId: String,
    name: String? = nil,
    character: Character? = nil,
    action: Action? = nil,
    location: Location? = nil,
    authorId: String? = nil,
    dateCreated: Date? = nil
  ) {
    self.avatarId = avatarId
    self.name = name
    self.character = character
    self.action = action
    self.location = location
    self.authorId = authorId
    self.dateCreated = dateCreated
  }
}

extension AvatarModel {
  enum Character: String {
    case man, woman, alien, dog, cat

    var phrase: String {
      let startsWithVowel = rawValue.lowercased().first.map { "aeiou".contains($0) } ?? false
      return "\(startsWithVowel ? "An" : "A") \(rawValue)"
    }
  }
}

extension AvatarModel {
  enum Action: String {
    case smiling, sitting, eating, drinking, walking, shopping, studying, working, relaxing, fighting, crying
  }
}

extension AvatarModel {
  enum Location: String {
    case park, mall, museum, city, dessert, forest, space

    var phrase: String {
      switch self {
      case .space: return "in space"
      default: return "in the \(rawValue)"
      }
    }
  }
}

extension AvatarModel {
  static var preview: AvatarModel {
    [AvatarModel].preview[0]
  }
}

extension [AvatarModel] {
  static var preview: [AvatarModel] {
    [
      AvatarModel(
        avatarId: "avatar_1",
        name: "Alpha",
        character: .man,
        action: .walking,
        location: .city,
        authorId: "author_1",
        dateCreated: .now
      ),
      AvatarModel(
        avatarId: "avatar_2",
        name: "Beta",
        character: .woman,
        action: .studying,
        location: .museum,
        authorId: "author_2",
        dateCreated: .now
      ),
      AvatarModel(
        avatarId: "avatar_3",
        name: "Gamma",
        character: .alien,
        action: .relaxing,
        location: .space,
        authorId: "author_3",
        dateCreated: .now
      ),
      AvatarModel(
        avatarId: "avatar_4",
        name: "Delta",
        character: .dog,
        action: .eating,
        location: .park,
        authorId: "author_4",
        dateCreated: .now
      ),
      AvatarModel(
        avatarId: "avatar_5",
        name: "Epsilon",
        character: .cat,
        action: .sitting,
        location: .forest,
        authorId: "author_5",
        dateCreated: .now
      )
    ]
  }
}
