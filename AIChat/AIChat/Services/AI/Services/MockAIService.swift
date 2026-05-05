//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

struct MockAIService: AIService {
  func generateImage(input: String) async throws -> UIImage {
    try await Task.sleep(for: .seconds(3))
    guard let image = UIImage(systemName: "star.fill") else {
      fatalError("SystemName was wrong")
    }
    return image
  }

  func generateText(messages: [AIChatMessage]) async throws -> String {
    try await Task.sleep(for: .seconds(1))
    return "This is a mock response from the AI."
  }
}
