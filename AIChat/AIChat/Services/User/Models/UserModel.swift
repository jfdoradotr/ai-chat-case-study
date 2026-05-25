//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct UserModel: Codable {
  let userId: String
  let email: String?
  let isAnonymous: Bool
  let creationDate: Date?
  let creationVersion: String?
  let lastSignInDate: Date?
  let didCompleteOnboarding: Bool
  let profileColorHex: String?

  init(
    userId: String,
    email: String? = nil,
    isAnonymous: Bool = false,
    creationDate: Date? = nil,
    creationVersion: String? = nil,
    lastSignInDate: Date? = nil,
    didCompleteOnboarding: Bool = false,
    profileColorHex: String? = nil
  ) {
    self.userId = userId
    self.email = email
    self.isAnonymous = isAnonymous
    self.creationDate = creationDate
    self.creationVersion = creationVersion
    self.lastSignInDate = lastSignInDate
    self.didCompleteOnboarding = didCompleteOnboarding
    self.profileColorHex = profileColorHex
  }

  init(auth: UserAuthInfo, creationVersion: String?) {
    self.init(
      userId: auth.uid,
      email: auth.email,
      isAnonymous: auth.isAnonymous,
      creationDate: auth.creationDate,
      creationVersion: creationVersion,
      lastSignInDate: auth.lastSignInDate,
    )
  }

  enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case email
    case isAnonymous = "is_anonymous"
    case creationDate = "creation_date"
    case creationVersion = "creation_version"
    case lastSignInDate = "last_sign_in_date"
    case didCompleteOnboarding = "did_complete_onboarding"
    case profileColorHex = "profile_color_hex"
  }

  var profileColor: Color {
    guard let profileColorHex else { return .accent }
    return Color(hex: profileColorHex) ?? .accent
  }

  var eventParameters: [String: Any] {
    var params: [String: Any] = [
      "user_id": userId,
      "user_is_anonymous": isAnonymous,
      "user_did_complete_onboarding": didCompleteOnboarding
    ]
    if let email { params["user_email"] = email }
    if let creationDate { params["user_creation_date"] = creationDate }
    if let creationVersion { params["user_creation_version"] = creationVersion }
    if let lastSignInDate { params["user_last_sign_in_date"] = lastSignInDate }
    if let profileColorHex { params["user_profile_color_hex"] = profileColorHex }
    return params
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
