//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct UserModel {
  let userId: String
  let dateCreated: Date?
  let didCompleteOnboarding: Bool
  let profileColorHex: String?

  init(
    userId: String,
    dateCreated: Date? = nil,
    didCompleteOnboarding: Bool = false,
    profileColorHex: String? = nil
  ) {
    self.userId = userId
    self.dateCreated = dateCreated
    self.didCompleteOnboarding = didCompleteOnboarding
    self.profileColorHex = profileColorHex
  }

  var profileColor: Color {
    guard let profileColorHex else { return .accent }
    return Color(hex: profileColorHex) ?? .accent
  }
}

extension UserModel {
  static var preview: UserModel { [UserModel].preview[0] }
}

extension [UserModel] {
  static var preview: [UserModel] {
    [
      UserModel(
        userId: "user_001",
        dateCreated: .now,
        didCompleteOnboarding: true,
        profileColorHex: "#FF5733"
      ),
      UserModel(
        userId: "user_002",
        dateCreated: .now.adding(days: -1),
        didCompleteOnboarding: false,
        profileColorHex: "#33C1FF"
      ),
      UserModel(
        userId: "user_003",
        dateCreated: .now.adding(days: -7),
        didCompleteOnboarding: true,
        profileColorHex: "#8E44AD"
      ),
      UserModel(
        userId: "user_004",
        dateCreated: .now.adding(days: -30),
        didCompleteOnboarding: false,
        profileColorHex: nil
      )
    ]
  }
}
