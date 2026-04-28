//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatView: View {
  @State private var chatMesages: [ChatMessageModel] = .preview

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        LazyVStack(spacing: 24) {
          ForEach(chatMesages) { message in
            Text(message.content ?? "")
          }
        }
        .frame(maxWidth: .infinity)
      }

      Rectangle()
        .frame(height: 50)
    }
  }
}

#Preview {
  ChatView()
}
