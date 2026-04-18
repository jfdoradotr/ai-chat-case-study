//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CarouselView: View {
  var body: some View {
    TabView {
      ForEach(0..<3) { index in
        Text("\(index)")
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .always))
    .indexViewStyle(.page(backgroundDisplayMode: .always))
  }
}

#Preview {
  CarouselView()
}
