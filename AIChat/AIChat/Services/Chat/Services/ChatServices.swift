//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

protocol ChatServices {
  var remote: any RemoteChatService { get }
}

@MainActor
struct MockChatServices: ChatServices {
  let remote: any RemoteChatService

  init(remote: any RemoteChatService = MockChatService()) {
    self.remote = remote
  }
}

@MainActor
struct ProductionChatServices: ChatServices {
  let remote: any RemoteChatService = FirebaseChatService()
}
