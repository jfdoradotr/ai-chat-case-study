//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct UserModel: Codable {
  let userId: String
  let email: String?
  let isAnonymous: Bool
  let creationDate: Date?
  let lastSignInDate: Date?
  let didCompleteOnboarding: Bool
  let profileColorHex: String?

  init(
    userId: String,
    email: String? = nil,
    isAnonymous: Bool = false,
    creationDate: Date? = nil,
    lastSignInDate: Date? = nil,
    didCompleteOnboarding: Bool = false,
    profileColorHex: String? = nil
  ) {
    self.userId = userId
    self.email = email
    self.isAnonymous = isAnonymous
    self.creationDate = creationDate
    self.lastSignInDate = lastSignInDate
    self.didCompleteOnboarding = didCompleteOnboarding
    self.profileColorHex = profileColorHex
  }

  init(auth: UserAuthInfo) {
    self.init(
      userId: auth.uid,
      email: auth.email,
      isAnonymous: auth.isAnonymous,
      creationDate: auth.creationDate,
      lastSignInDate: auth.lastSignInDate,
    )
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
        creationDate: .now,
        didCompleteOnboarding: true,
        profileColorHex: "#FF5733"
      ),
      UserModel(
        userId: "user_002",
        creationDate: .now.adding(days: -1),
        didCompleteOnboarding: false,
        profileColorHex: "#33C1FF"
      ),
      UserModel(
        userId: "user_003",
        creationDate: .now.adding(days: -7),
        didCompleteOnboarding: true,
        profileColorHex: "#8E44AD"
      ),
      UserModel(
        userId: "user_004",
        creationDate: .now.adding(days: -30),
        didCompleteOnboarding: false,
        profileColorHex: nil
      )
    ]
  }
}
