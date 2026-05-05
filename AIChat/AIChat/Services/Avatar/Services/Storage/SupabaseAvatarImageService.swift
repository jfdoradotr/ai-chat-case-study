//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Storage
import UIKit

struct SupabaseAvatarImageService: AvatarImageService {
  private let bucket = "avatars"

  // swiftlint:disable force_unwrapping
  private var client: SupabaseStorageClient {
    SupabaseStorageClient(
      configuration: StorageClientConfiguration(
        url: URL(string: "\(Keys.Supabase.projectURL)/storage/v1")!,
        headers: [
          "apikey": Keys.Supabase.publishableKey,
          "Authorization": "Bearer \(Keys.Supabase.publishableKey)"
        ],
        logger: nil
      )
    )
  }
  // swiftlint:enable force_unwrapping


  func uploadAvatarImage(_ image: UIImage, path: String) async throws -> URL {
    guard let data = image.jpegData(compressionQuality: 0.85) else {
      throw AvatarImageError.invalidImageData
    }

    try await client.from(bucket).upload(
      path: path,
      file: data,
      options: FileOptions(contentType: "image/jpeg")
    )

    return try client.from(bucket).getPublicURL(path: path)
  }

  enum AvatarImageError: LocalizedError {
    case invalidImageData

    var errorDescription: String? {
      switch self {
      case .invalidImageData: return "Could not encode image as JPEG."
      }
    }
  }
}
