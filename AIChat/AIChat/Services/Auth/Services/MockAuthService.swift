//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

struct MockAuthService: AuthService {
  let currentUser: UserAuthInfo?
  let isNewUser: Bool

  init(user: UserAuthInfo? = .preview, isNewUser: Bool = false) {
    self.currentUser = user
    self.isNewUser = isNewUser
  }

  func getAuthenticatedUser() -> UserAuthInfo? {
    currentUser
  }

  func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
    guard let currentUser else { throw MockError.noMockUser }
    return (currentUser, isNewUser)
  }

  func signInGoogle() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
    guard let currentUser else { throw MockError.noMockUser }
    return (currentUser, isNewUser)
  }

  func signOut() throws {}

  func deleteAccount() async throws {}

  enum MockError: Error {
    case noMockUser
  }
}
