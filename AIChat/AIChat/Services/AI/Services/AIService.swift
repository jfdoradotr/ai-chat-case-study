//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

protocol AIService {
  func generateImage(input: String) async throws -> UIImage
}
