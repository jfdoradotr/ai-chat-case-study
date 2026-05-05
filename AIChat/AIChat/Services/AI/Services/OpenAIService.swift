//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import OpenAI
import SwiftUI

struct OpenAIService: AIService {
  var openAI: OpenAI {
    OpenAI(apiToken: Keys.OpenAI.apiToken)
  }

  func generateImage(input: String) async throws -> UIImage {
    let query = ImagesQuery(
      prompt: input,
      model: .dall_e_2,
      n: 1,
      responseFormat: .b64_json,
      size: ._512
    )

    let result = try await openAI.images(query: query)

    guard
      let b64json = result.data.first?.b64Json,
      let data = Data(base64Encoded: b64json),
      let image = UIImage(data: data)
    else {
      throw OpenAIError.invalidResponse
    }

    return image
  }

  func generateText(messages: [AIChatMessage]) async throws -> String {
    let chatMessages = messages.compactMap { message -> ChatQuery.ChatCompletionMessageParam? in
      let role: ChatQuery.ChatCompletionMessageParam.Role
      switch message.role {
      case .system: role = .system
      case .user: role = .user
      case .assistant: role = .assistant
      }
      return ChatQuery.ChatCompletionMessageParam(role: role, content: message.content)
    }

    let query = ChatQuery(messages: chatMessages, model: .gpt4_o_mini)
    let result = try await openAI.chats(query: query)

    guard let content = result.choices.first?.message.content else {
      throw OpenAIError.invalidResponse
    }
    return content
  }

  enum OpenAIError: LocalizedError {
    case invalidResponse
  }
}
