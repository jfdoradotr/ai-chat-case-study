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
}
