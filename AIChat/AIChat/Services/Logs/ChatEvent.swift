//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum ChatEvent: LoggableEvent {
  case loadAvatarStart
  case loadAvatarSuccess(avatarId: String)
  case loadAvatarFailure(error: any Error)
  case loadChatStart
  case loadChatSuccess(chat: ChatModel?)
  case loadChatFailure(error: any Error)
  case messagesListenStart(chatId: String)
  case messagesListenFailure(error: any Error)
  case sendMessagePressed
  case sendMessageValidationFailure(error: any Error)
  case sendMessageStart(chat: ChatModel?, message: ChatMessageModel)
  case sendMessageSuccess(chat: ChatModel, message: ChatMessageModel)
  case sendMessageFailure(error: any Error)
  case generateResponseStart(chat: ChatModel)
  case generateResponseSuccess(chat: ChatModel, message: ChatMessageModel)
  case generateResponseFailure(error: any Error)
  case deleteChatPressed(chat: ChatModel?)
  case deleteChatSuccess(chat: ChatModel)
  case deleteChatFailure(error: any Error)
  case avatarImagePressed(avatarId: String?)

  var eventName: String {
    switch self {
    case .loadAvatarStart: return "Chat_LoadAvatar_Start"
    case .loadAvatarSuccess: return "Chat_LoadAvatar_Success"
    case .loadAvatarFailure: return "Chat_LoadAvatar_Failure"
    case .loadChatStart: return "Chat_LoadChat_Start"
    case .loadChatSuccess: return "Chat_LoadChat_Success"
    case .loadChatFailure: return "Chat_LoadChat_Failure"
    case .messagesListenStart: return "Chat_MessagesListen_Start"
    case .messagesListenFailure: return "Chat_MessagesListen_Failure"
    case .sendMessagePressed: return "Chat_SendMessage_Pressed"
    case .sendMessageValidationFailure: return "Chat_SendMessage_ValidationFailure"
    case .sendMessageStart: return "Chat_SendMessage_Start"
    case .sendMessageSuccess: return "Chat_SendMessage_Success"
    case .sendMessageFailure: return "Chat_SendMessage_Failure"
    case .generateResponseStart: return "Chat_GenerateResponse_Start"
    case .generateResponseSuccess: return "Chat_GenerateResponse_Success"
    case .generateResponseFailure: return "Chat_GenerateResponse_Failure"
    case .deleteChatPressed: return "Chat_DeleteChat_Pressed"
    case .deleteChatSuccess: return "Chat_DeleteChat_Success"
    case .deleteChatFailure: return "Chat_DeleteChat_Failure"
    case .avatarImagePressed: return "Chat_AvatarImage_Pressed"
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .loadAvatarStart, .loadChatStart, .sendMessagePressed:
      return [:]

    case .loadAvatarSuccess(let avatarId):
      return ["avatar_id": avatarId]

    case .loadChatSuccess(let chat):
      var params: [String: Any] = ["did_exist": chat != nil]
      if let chat {
        params.merge(chat.eventParameters) { _, new in new }
      }
      return params

    case .messagesListenStart(let chatId):
      return ["chat_id": chatId]

    case let .sendMessageStart(chat, message):
      var params = message.eventParameters
      if let chat {
        params.merge(chat.eventParameters) { _, new in new }
      }
      return params

    case let .sendMessageSuccess(chat, message), let .generateResponseSuccess(chat, message):
      var params = message.eventParameters
      params.merge(chat.eventParameters) { _, new in new }
      return params

    case .generateResponseStart(let chat), .deleteChatSuccess(let chat):
      return chat.eventParameters

    case .deleteChatPressed(let chat):
      var params: [String: Any] = ["did_exist": chat != nil]
      if let chat {
        params.merge(chat.eventParameters) { _, new in new }
      }
      return params

    case .avatarImagePressed(let avatarId):
      return ["avatar_id": avatarId ?? ""]

    case .loadAvatarFailure(let error),
      .loadChatFailure(let error),
      .messagesListenFailure(let error),
      .sendMessageValidationFailure(let error),
      .sendMessageFailure(let error),
      .generateResponseFailure(let error),
      .deleteChatFailure(let error):
      return ["error_type": String(describing: type(of: error)), "error": error.localizedDescription]
    }
  }
}
