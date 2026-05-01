//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

protocol UserService {

}

@MainActor
@Observable
final class UserManager {
  private let service: any UserService
  private(set) var currentUser: UserModel?

  init(service: any UserService) {
    self.service = service
    self.currentUser = nil
  }

  func login(auth: UserAuthInfo, isNewUser: Bool) async throws {

  }
}
