//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CreateAvatarView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(AIManager.self) private var aiManager

  @State private var name: String = ""
  @State private var option: AvatarModel.Character = .man
  @State private var action: AvatarModel.Action = .smiling
  @State private var location: AvatarModel.Location = .park

  @State private var isGenerating = false
  @State private var generatedImage: UIImage?
  @State private var isCompletingCreateAvatar = false

  var body: some View {
    List {
      nameSection
      attributesSection
      imageSection
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
    .safeAreaInset(edge: .bottom) {
      PrimaryButton(
        title: "Save",
        isLoading: isCompletingCreateAvatar,
        action: onSavePressed
      )
      .padding(.horizontal)
      .disabled(generatedImage == nil || name.isEmpty)
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
    isGenerating = true
    Task {
      let prompt = AvatarModel.description(
        character: option,
        action: action,
        location: location
      )
      do {
        generatedImage = try await aiManager.generateImage(input: prompt)
      } catch {
        print("Failed to generate image: \(error)")
      }
      isGenerating = false
    }
  }

  private func onSavePressed() {
    isCompletingCreateAvatar = true
    Task {
      try? await Task.sleep(for: .seconds(3))
      await MainActor.run {
        isCompletingCreateAvatar = false
      }
    }
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

  private var imageSection: some View {
    Section {
      VStack(spacing: 16) {
        ZStack {
          Button("Generate image", action: onGenerateImagePressed)
            .buttonStyle(.glassProminent)
            .opacity(isGenerating ? 0 : 1)
            .allowsHitTesting(!isGenerating)
          ProgressView()
            .controlSize(.regular)
            .tint(.accent)
            .opacity(isGenerating ? 1 : 0)
        }
        .disabled(isCompletingCreateAvatar || isGenerating || name.isEmpty)
        Circle()
          .fill(.secondary.opacity(0.3))
          .frame(width: 250, height: 250)
          .overlay(
            ZStack {
              if let generatedImage {
                Image(uiImage: generatedImage)
                  .resizable()
                  .scaledToFill()
              }
            }
          )
          .clipShape(Circle())
      }
      .frame(maxWidth: .infinity)
    }
  }
}

#Preview {
  NavigationStack {
    CreateAvatarView()
      .environment(AIManager(service: MockAIService()))
  }
}
