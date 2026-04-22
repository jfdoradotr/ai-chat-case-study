//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI
import UIKit

extension Color {
  init?(hex: String) {
    var sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if sanitized.hasPrefix("#") {
      sanitized.removeFirst()
    }

    guard sanitized.count == 6 || sanitized.count == 8 else {
      return nil
    }

    var value: UInt64 = 0
    guard Scanner(string: sanitized).scanHexInt64(&value) else {
      return nil
    }

    let red, green, blue, alpha: Double
    if sanitized.count == 6 {
      red = Double((value & 0xFF0000) >> 16) / 255
      green = Double((value & 0x00FF00) >> 8) / 255
      blue = Double(value & 0x0000FF) / 255
      alpha = 1
    } else {
      red = Double((value & 0xFF000000) >> 24) / 255
      green = Double((value & 0x00FF0000) >> 16) / 255
      blue = Double((value & 0x0000FF00) >> 8) / 255
      alpha = Double(value & 0x000000FF) / 255
    }

    self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
  }

  func asHex(includeAlpha: Bool = false) -> String? {
    let uiColor = UIColor(self)
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0

    guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
      return nil
    }

    let redInt = Int((red * 255).rounded())
    let greenInt = Int((green * 255).rounded())
    let blueInt = Int((blue * 255).rounded())

    if includeAlpha {
      let alphaInt = Int((alpha * 255).rounded())
      return String(format: "#%02X%02X%02X%02X", redInt, greenInt, blueInt, alphaInt)
    } else {
      return String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
    }
  }
}
