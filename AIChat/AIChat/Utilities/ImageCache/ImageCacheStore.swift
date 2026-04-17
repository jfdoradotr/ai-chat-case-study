//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit
import CryptoKit

// NSCache requires Objective-C reference types as keys (NSURL/NSString).
// Swift has no native equivalent that auto-purges under memory pressure.
// swiftlint:disable legacy_objc_type

actor ImageCacheStore: ImageCache {
  static let shared = ImageCacheStore()

  private let memoryCache = NSCache<NSURL, UIImage>()
  private let cacheDirectory: URL

  init(subfolder: String = "ImageCache") {
    let manager = FileManager.default
    let base = manager
      .urls(for: .cachesDirectory, in: .userDomainMask)
      .first ?? URL(fileURLWithPath: NSTemporaryDirectory())
    cacheDirectory = base.appendingPathComponent(subfolder, isDirectory: true)
    try? manager.createDirectory(
      at: cacheDirectory,
      withIntermediateDirectories: true
    )
  }

  func image(for url: URL) async -> UIImage? {
    let key = url as NSURL
    if let cached = memoryCache.object(forKey: key) {
      return cached
    }
    let fileURL = diskURL(for: url)
    guard
      FileManager.default.fileExists(atPath: fileURL.path),
      let data = try? Data(contentsOf: fileURL),
      let image = UIImage(data: data)
    else {
      return nil
    }
    memoryCache.setObject(image, forKey: key)
    return image
  }

  func store(_ image: UIImage, for url: URL) async {
    let key = url as NSURL
    memoryCache.setObject(image, forKey: key)
    let fileURL = diskURL(for: url)
    if let data = image.jpegData(compressionQuality: 0.8) {
      try? data.write(to: fileURL, options: .atomic)
    }
  }

  private func diskURL(for url: URL) -> URL {
    let digest = SHA256.hash(data: Data(url.absoluteString.utf8))
    let hash = digest.map { String(format: "%02x", $0) }.joined()
    return cacheDirectory.appendingPathComponent("\(hash).jpg")
  }
}

// swiftlint:enable legacy_objc_type
