//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

extension View {
  @MainActor
  func previewEnvironment(
    isSignedIn: Bool = true,
    avatarRemote: (any RemoteAvatarService)? = nil
  ) -> some View {
    let user: UserModel? = isSignedIn ? .preview : nil
    let authUser: UserAuthInfo? = isSignedIn ? .preview : nil
    let avatarServices: any AvatarServices = avatarRemote
      .map { MockAvatarServices(remote: $0) } ?? MockAvatarServices()

    return self
      .environment(AppState())
      .environment(AuthManager(service: MockAuthService(user: authUser)))
      .environment(UserManager(services: MockUserServices(user: user)))
      .environment(AvatarManager(services: avatarServices))
      .environment(AIManager(service: MockAIService()))
      .environment(ChatManager(services: MockChatServices()))
      .environment(LogManager(services: [ConsoleLogService()]))
  }
}
