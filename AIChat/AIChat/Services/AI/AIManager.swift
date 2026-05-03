//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import OpenAI
import UIKit

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
