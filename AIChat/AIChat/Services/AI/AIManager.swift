//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import OpenAI
import UIKit

protocol AIService {
  func generateImage(input: String) async throws -> UIImage
}

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

  enum OpenAIError: LocalizedError {
    case invalidResponse
  }
}

@MainActor
@Observable
final class AIManager {
  private let service: any AIService

  init(service: any AIService) {
    self.service = service
  }

  func generateImage(input: String) async throws -> UIImage {
    try await service.generateImage(input: input)
  }
}
