//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

protocol AIService {
  func generateImage(input: String) async throws -> UIImage
  func generateText(messages: [AIChatMessage]) async throws -> String
}

struct AIChatMessage: Sendable {
  enum Role: String, Sendable {
    case system, user, assistant
  }

  let role: Role
  let content: String
}
