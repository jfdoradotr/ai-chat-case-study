//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

protocol LocalUserPersistence: Sendable {
  func getCurrentUser() -> UserModel?
  func saveCurrentUser(user: UserModel?) throws
}
