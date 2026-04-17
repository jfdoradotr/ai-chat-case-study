//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

protocol ImageCache: Sendable {
  func image(for url: URL) async -> UIImage?
  func store(_ image: UIImage, for url: URL) async
}
