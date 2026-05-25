//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum ChatsEvent: LoggableEvent {
  case loadRecentAvatarsStart
  case loadRecentAvatarsSuccess(count: Int)
  case loadRecentAvatarsFailure(error: any Error)
  case listenChatsStart
  case listenChatsSuccess(count: Int)
  case listenChatsFailure(error: any Error)
  case recentAvatarPressed(avatarId: String)
  case chatRowPressed(chat: ChatModel)

  var eventName: String {
    switch self {
    case .loadRecentAvatarsStart: return "Chats_LoadRecentAvatars_Start"
    case .loadRecentAvatarsSuccess: return "Chats_LoadRecentAvatars_Success"
    case .loadRecentAvatarsFailure: return "Chats_LoadRecentAvatars_Failure"
    case .listenChatsStart: return "Chats_ListenChats_Start"
    case .listenChatsSuccess: return "Chats_ListenChats_Success"
    case .listenChatsFailure: return "Chats_ListenChats_Failure"
    case .recentAvatarPressed: return "Chats_RecentAvatar_Pressed"
    case .chatRowPressed: return "Chats_ChatRow_Pressed"
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .loadRecentAvatarsStart, .listenChatsStart:
      return [:]

    case .loadRecentAvatarsSuccess(let count), .listenChatsSuccess(let count):
      return ["count": count, "is_empty": count == 0]

    case .recentAvatarPressed(let avatarId):
      return ["avatar_id": avatarId]

    case .chatRowPressed(let chat):
      return chat.eventParameters

    case .loadRecentAvatarsFailure(let error),
      .listenChatsFailure(let error):
      return ["error_type": String(describing: type(of: error)), "error": error.localizedDescription]
    }
  }
}
