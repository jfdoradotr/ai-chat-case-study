//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct UserAuthInfo {
  let uid: String
  let email: String?
  let isAnonymous: Bool
  let creationDate: Date?
  let lastSignInDate: Date?
}

extension UserAuthInfo {
  static var preview: UserAuthInfo {
    UserAuthInfo(
      uid: "preview_uid_123",
      email: "preview@example.com",
      isAnonymous: false,
      creationDate: .now,
      lastSignInDate: .now
    )
  }

  static var anonymousPreview: UserAuthInfo {
    UserAuthInfo(
      uid: "anonymous_preview_uid_123",
      email: nil,
      isAnonymous: true,
      creationDate: .now,
      lastSignInDate: .now
    )
  }
}
