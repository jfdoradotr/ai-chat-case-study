//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

enum TextValidationError: LocalizedError {
  case emptyMessage
  case badWord

  var errorDescription: String? {
    switch self {
    case .emptyMessage:
      "Your message is empty. Please type something."

    case .badWord:
      "Your message contains inappropriate language. Please revise it."
    }
  }
}

struct TextValidator {
  var blockedWords: Set<String> = [
    "idiota", "estupido", "imbecil", "maldito", "bastardo",
    "idiot", "stupid", "damn", "bastard", "moron"
  ]

  func validate(_ text: String) throws -> String {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { throw TextValidationError.emptyMessage }
    let words = trimmed.lowercased().components(separatedBy: .whitespacesAndNewlines)
    guard words.allSatisfy({ !blockedWords.contains($0) }) else { throw TextValidationError.badWord }
    return trimmed
  }
}
