//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct DevSettingsView: View {
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    List {
      Section("Build") {
        LabeledContent("Configuration", value: "\(BuildConfiguration.current)")
      }
    }
    .navigationTitle("Developer Settings")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("Done") { dismiss() }
      }
    }
  }
}
