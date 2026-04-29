//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

extension View {
  @ViewBuilder func ifSatisfiedCondition(_ condition: Bool, transform: (Self) -> some View) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}
