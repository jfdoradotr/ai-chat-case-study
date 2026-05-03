//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

protocol AvatarImageService: Sendable {
  func uploadAvatarImage(_ image: UIImage, path: String) async throws -> URL
}
