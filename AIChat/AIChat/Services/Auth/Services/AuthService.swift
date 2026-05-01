//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

extension EnvironmentValues {
  @Entry var authService: any AuthService = FirebaseAuthService()
}

protocol AuthService: Sendable {
  func addAuthenticatedUserListener(onListenerAttached: (any NSObjectProtocol) -> Void) -> AsyncStream<UserAuthInfo?>
  func getAuthenticatedUser() -> UserAuthInfo?
  func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool)
  func signInGoogle() async throws -> (user: UserAuthInfo, isNewUser: Bool)
  func signOut() throws
  func deleteAccount() async throws
}
