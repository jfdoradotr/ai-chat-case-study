//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

struct MockAvatarImageService: AvatarImageService {
  func uploadAvatarImage(_ image: UIImage, path: String) async throws -> URL {
    URL(string: "https://example.com/\(path)")! // swiftlint:disable:this force_unwrapping
  }
}
