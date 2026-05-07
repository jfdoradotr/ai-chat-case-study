//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatDayHeaderView: View {
  let date: Date

  var body: some View {
    Text(date.chatDayLabel())
      .font(.caption)
      .fontWeight(.semibold)
      .foregroundStyle(.secondary)
      .padding(.vertical, 6)
      .padding(.horizontal, 14)
      .background(Capsule().fill(.ultraThinMaterial))
      .frame(maxWidth: .infinity)
  }
}

#Preview {
  VStack(spacing: 12) {
    ChatDayHeaderView(date: .now)
    ChatDayHeaderView(date: .now.adding(days: -1))
    ChatDayHeaderView(date: .now.adding(days: -3))
    ChatDayHeaderView(date: .now.adding(days: -10))
  }
  .padding()
}
