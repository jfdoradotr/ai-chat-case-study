//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatView: View {
  enum ChatValidationError: LocalizedError {
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

  @State private var chatMesages: [ChatMessageModel] = .preview
  @State private var avatar: AvatarModel? = .preview
  @State private var currentUser: UserModel? = .preview
  @State private var messageText: String = ""
  @State private var showSettings = false
  @State private var scrollPosition: String?
  @State private var validationError: ChatValidationError?

  var body: some View {
    VStack(spacing: 0) {
      scrollViewSection
      textFieldSection
    }
    .navigationTitle(avatar?.name ?? "Chat")
    .toolbarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button("Menu", systemImage: "ellipsis", action: onSettingsButtonTapped)
      }
    }
    .alert(
      "Message Not Sent",
      isPresented: Binding(
        get: { validationError != nil },
        set: { if !$0 { validationError = nil } }
      )
    ) {
      Button("OK", role: .cancel, action: {})
    } message: {
      Text(validationError?.localizedDescription ?? "")
    }
    .confirmationDialog("What would you like to do?", isPresented: $showSettings) {
      Button("Report User/Chat", role: .destructive, action: onReportButtonTapped)
      Button("Delete Chat", role: .destructive, action: onReportButtonTapped)
      Button("Cancel", role: .cancel, action: {})
    } message: {
      Text("What would you like to do?")
    }
  }

  private var scrollViewSection: some View {
    ScrollView {
      LazyVStack(spacing: 24) {
        ForEach(chatMesages) { message in
          let isCurrentUser = message.authorId == currentUser?.userId
          ChatBubbleViewBuilder(
            message: message,
            isCurrentUser: isCurrentUser,
            imageURL: avatar?.imageURL
          )
          .id(message.id)
        }
      }
      .scrollTargetLayout()
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 8)
    }
    .defaultScrollAnchor(.bottom)
    .scrollPosition(id: $scrollPosition, anchor: .center)
    .animation(.default, value: chatMesages.count)
    .animation(.default, value: scrollPosition)
  }

  private var textFieldSection: some View {
    TextField("Say something...", text: $messageText)
      .keyboardType(.alphabet)
      .autocorrectionDisabled()
      .padding(12)
      .padding(.trailing, 40)
      .overlay(
        Button(action: onSendButtonTapped) {
          Label("Send Message", systemImage: "arrow.up.circle.fill")
            .labelStyle(.iconOnly)
            .font(.largeTitle)
        }.padding(.trailing, 4),
        alignment: .trailing
      )
      .background(
        ZStack {
          RoundedRectangle(cornerRadius: 100)
            .fill(Color(.systemBackground))
          RoundedRectangle(cornerRadius: 100)
            .stroke(Color.gray.opacity(0.03), lineWidth: 1)
        }
      )
      .padding(.horizontal, 12)
      .padding(.vertical, 6)
      .background(Color(.secondarySystemBackground))
  }

  private let blockedWords: Set<String> = [
    "idiota", "estupido", "imbecil", "maldito", "bastardo",
    "idiot", "stupid", "damn", "bastard", "moron"
  ]

  private func checkIfMessageIsValid() throws {
    let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { throw ChatValidationError.emptyMessage }
    let words = trimmed.lowercased().components(separatedBy: .whitespacesAndNewlines)
    guard words.allSatisfy({ !blockedWords.contains($0) }) else { throw ChatValidationError.badWord }
  }

  private func onSendButtonTapped() {
    guard let currentUser else { return }
    do {
      try checkIfMessageIsValid()
    } catch let error as ChatValidationError {
      validationError = error
      return
    } catch { return }
    let content = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
    let message = ChatMessageModel(
      id: UUID().uuidString,
      chatId: UUID().uuidString,
      authorId: currentUser.userId,
      content: content,
      seenByIds: [],
      dateCreated: .now
    )
    chatMesages.append(message)
    scrollPosition = message.id
    messageText = ""
  }

  private func onSettingsButtonTapped() {
    showSettings = true
  }

  private func onReportButtonTapped() {}
}

#Preview {
  NavigationStack {
    ChatView()
  }
}
