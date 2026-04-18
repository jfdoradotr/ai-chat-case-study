//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct AvatarModel {
  let avatarId: String
  let name: String
  let character: Character?
  let action: Action?
  let location: Location?
  let authorId: String?
  let dateCreated: Date?
}

extension AvatarModel {
  enum Character {
    case man, woman, alien, dog, cat
  }
}

extension AvatarModel {
  enum Action {
    case smiling, sitting, eating, drinking, walking, shopping, studying, working, relaxing, fighting, crying
  }
}

extension AvatarModel {
  enum Location {
    case park, mall, museum, city, dessert, forest, space
  }
}
