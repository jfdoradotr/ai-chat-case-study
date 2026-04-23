//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CreateAvatarView: View {
  @Environment(\.dismiss) private var dismiss

  @State private var name: String = ""
  @State private var option: AvatarModel.Character = .man
  @State private var action: AvatarModel.Action = .smiling
  @State private var location: AvatarModel.Location = .park

  var body: some View {
    List {
      nameSection
      attributesSection
      Section {
        VStack(spacing: 16) {
          Button("Generate image", action: onGenerateImagePressed)
            .buttonStyle(.glassProminent)
          Circle()
            .fill(.secondary.opacity(0.3))
            .frame(width: 250, height: 250)
            .overlay(
              Image(systemName: "star.fill")
                .resizable()
                .scaledToFill()
                .padding(24)
            )
            .clipShape(Circle())
        }
        .frame(maxWidth: .infinity)
      }
      .listRowInsets(EdgeInsets())
      .listRowBackground(Color.clear)
    }
    .navigationTitle("Create Avatar")
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button(
          "Close",
          systemImage: "xmark",
          role: .close,
          action: onClosePressed
        )
      }
    }
  }

  private func onClosePressed() {
    dismiss()
  }

  private func onGenerateImagePressed() {
  }

  private var nameSection: some View {
    Section {
      TextField("Jarvis", text: $name)
    } header: {
      Text("Name your avatar*")
    }
  }

  private var attributesSection: some View {
    Section {
      Picker(selection: $option) {
        ForEach(AvatarModel.Character.allCases, id: \.self) { option in
          Text(option.rawValue.capitalized)
            .tag(option)
        }
      } label: {
        Text("is a")
      }
      Picker(selection: $action) {
        ForEach(AvatarModel.Action.allCases, id: \.self) { option in
          Text(option.rawValue.capitalized)
            .tag(option)
        }
      } label: {
        Text("that is")
      }
      Picker(selection: $location) {
        ForEach(AvatarModel.Location.allCases, id: \.self) { option in
          Text(option.rawValue.capitalized)
            .tag(option)
        }
      } label: {
        Text("in the")
      }
    } header: {
      Text("Attributes")
    }
  }
}

#Preview {
  NavigationStack {
    CreateAvatarView()
  }
}
