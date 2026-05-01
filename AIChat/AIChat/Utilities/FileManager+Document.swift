//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

extension FileManager {
  enum DocumentError: LocalizedError {
    case documentsDirectoryUnavailable
    case invalidKey(String)
    case encodingFailed(any Error)
    case decodingFailed(any Error)
    case writeFailed(any Error)
    case readFailed(any Error)
    case deleteFailed(any Error)
    case fileNotFound(String)

    var errorDescription: String? {
      switch self {
      case .documentsDirectoryUnavailable:
        return "Could not locate the user's documents directory."
      case .invalidKey(let key):
        return "Invalid document key: '\(key)'."
      case .encodingFailed(let error):
        return "Failed to encode document: \(error.localizedDescription)"
      case .decodingFailed(let error):
        return "Failed to decode document: \(error.localizedDescription)"
      case .writeFailed(let error):
        return "Failed to write document to disk: \(error.localizedDescription)"
      case .readFailed(let error):
        return "Failed to read document from disk: \(error.localizedDescription)"
      case .deleteFailed(let error):
        return "Failed to delete document: \(error.localizedDescription)"
      case .fileNotFound(let key):
        return "No document found for key '\(key)'."
      }
    }
  }

  static func saveDocument<T: Encodable>(key: String, value: T?) throws {
    let url = try documentURL(for: key)

    guard let value else {
      guard FileManager.default.fileExists(atPath: url.path) else { return }
      do {
        try FileManager.default.removeItem(at: url)
      } catch {
        throw DocumentError.deleteFailed(error)
      }
      return
    }

    let data: Data
    do {
      data = try JSONEncoder().encode(value)
    } catch {
      throw DocumentError.encodingFailed(error)
    }

    do {
      try data.write(to: url, options: [.atomic])
    } catch {
      throw DocumentError.writeFailed(error)
    }
  }

  static func getDocument<T: Decodable>(key: String) throws -> T {
    let url = try documentURL(for: key)

    guard FileManager.default.fileExists(atPath: url.path) else {
      throw DocumentError.fileNotFound(key)
    }

    let data: Data
    do {
      data = try Data(contentsOf: url)
    } catch {
      throw DocumentError.readFailed(error)
    }

    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      throw DocumentError.decodingFailed(error)
    }
  }

  private static func documentURL(for key: String) throws -> URL {
    let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      throw DocumentError.invalidKey(key)
    }
    guard let directory = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask
    ).first else {
      throw DocumentError.documentsDirectoryUnavailable
    }
    return directory.appendingPathComponent("\(trimmed).txt")
  }
}
