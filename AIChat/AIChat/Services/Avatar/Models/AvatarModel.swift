//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct AvatarModel: Identifiable, Codable {
  let avatarId: String
  let name: String?
  let character: Character?
  let action: Action?
  let location: Location?
  let authorId: String?
  let dateCreated: Date?
  let imageURL: URL?
  let clickCount: Int?

  var id: String { avatarId }

  enum CodingKeys: String, CodingKey {
    case avatarId = "avatar_id"
    case name
    case character
    case action
    case location
    case authorId = "author_id"
    case dateCreated = "date_created"
    case imageURL = "image_url"
    case clickCount = "click_count"
  }

  var description: String {
    Self.description(character: character, action: action, location: location)
  }

  static func description(
    character: Character?,
    action: Action?,
    location: Location?
  ) -> String {
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
    dateCreated: Date? = nil,
    imageURL: URL? = nil,
    clickCount: Int? = nil
  ) {
    self.avatarId = avatarId
    self.name = name
    self.character = character
    self.action = action
    self.location = location
    self.authorId = authorId
    self.dateCreated = dateCreated
    self.imageURL = imageURL
    self.clickCount = clickCount
  }

  func withImageURL(_ imageURL: URL?) -> Self {
    Self(
      avatarId: avatarId,
      name: name,
      character: character,
      action: action,
      location: location,
      authorId: authorId,
      dateCreated: dateCreated,
      imageURL: imageURL,
      clickCount: clickCount
    )
  }
}

extension AvatarModel {
  enum Character: String, CaseIterable, Codable {
    case man, woman, alien, dog, cat

    var plural: String {
      switch self {
      case .man: "Men"
      case .woman: "Women"
      default: "\(rawValue.capitalized)s"
      }
    }

    var phrase: String {
      let startsWithVowel = rawValue.lowercased().first.map { "aeiou".contains($0) } ?? false
      return "\(startsWithVowel ? "An" : "A") \(rawValue)"
    }
  }
}

extension AvatarModel {
  enum Action: String, CaseIterable, Codable {
    case smiling, sitting, eating, drinking, walking, shopping, studying, working, relaxing, fighting, crying
  }
}

extension AvatarModel {
  enum Location: String, CaseIterable, Codable {
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
        dateCreated: .now,
        imageURL: Constants.randomImageURL
      ),
      AvatarModel(
        avatarId: "avatar_2",
        name: "Beta",
        character: .woman,
        action: .studying,
        location: .museum,
        authorId: "author_2",
        dateCreated: .now,
        imageURL: Constants.randomImageURL
      ),
      AvatarModel(
        avatarId: "avatar_3",
        name: "Gamma",
        character: .alien,
        action: .relaxing,
        location: .space,
        authorId: "author_3",
        dateCreated: .now,
        imageURL: Constants.randomImageURL
      ),
      AvatarModel(
        avatarId: "avatar_4",
        name: "Delta",
        character: .dog,
        action: .eating,
        location: .park,
        authorId: "author_4",
        dateCreated: .now,
        imageURL: Constants.randomImageURL
      ),
      AvatarModel(
        avatarId: "avatar_5",
        name: "Epsilon",
        character: .cat,
        action: .sitting,
        location: .forest,
        authorId: "author_5",
        dateCreated: .now,
        imageURL: Constants.randomImageURL
      )
    ]
  }
}
