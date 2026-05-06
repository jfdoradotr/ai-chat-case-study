//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatView: View {
  @Environment(AvatarManager.self) private var avatarManager
  @Environment(AIManager.self) private var aiManager
  @Environment(ChatManager.self) private var chatManager

  @State private var chatMesages: [ChatMessageModel] = []
  @State private var chat: ChatModel?
  @State private var avatar: AvatarModel?
  @State private var currentUser: UserModel? = .preview
  @State private var messageText: String = ""
  @State private var showSettings = false
  @State private var scrollPosition: String?
  @State private var validationError: TextValidationError?
  @State private var showProfileModal = false
  @State private var errorMessage: String?
  @State private var isGenerating = false

  private let textValidator = TextValidator()

  var avatarId: String = AvatarModel.preview.avatarId

  var body: some View {
    VStack(spacing: 0) {
      scrollViewSection
      textFieldSection
    }
    .showModal(isPresented: $showProfileModal) {
      if let avatar {
        ProfileModalView(
          imageURL: avatar.imageURL,
          title: avatar.name,
          subtitle: avatar.character?.rawValue.capitalized,
          headline: avatar.description
        ) {
          showProfileModal = false
        }
        .padding(40)
        .transition(.slide)
      }
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
    .alert(
      "Something went wrong",
      isPresented: Binding(
        get: { errorMessage != nil },
        set: { if !$0 { errorMessage = nil } }
      ),
      presenting: errorMessage
    ) { _ in
      Button("OK", role: .cancel) {}
    } message: { message in
      Text(message)
    }
    .task {
      async let avatarTask: () = loadAvatar()
      async let chatTask: () = loadExistingChat()
      _ = await (avatarTask, chatTask)
    }
    .task(id: chat?.id) {
      guard let chatId = chat?.id else { return }
      await listenToMessages(chatId: chatId)
    }
  }

  private func loadAvatar() async {
    do {
      let loaded = try await avatarManager.getAvatar(id: avatarId)
      self.avatar = loaded
      try? await avatarManager.addRecentAvatar(loaded)
    } catch {
      errorMessage = "Failed to load avatar: \(error.localizedDescription)"
    }
  }

  private func loadExistingChat() async {
    guard let userId = currentUser?.userId else { return }
    do {
      guard let existing = try await chatManager.getChat(userId: userId, avatarId: avatarId) else {
        return
      }
      self.chat = existing
    } catch {
      errorMessage = "Failed to load chat: \(error.localizedDescription)"
    }
  }

  private func listenToMessages(chatId: String) async {
    do {
      for try await messages in chatManager.streamMessages(forChatId: chatId) {
        self.chatMesages = messages
      }
    } catch {
      errorMessage = "Lost connection to chat: \(error.localizedDescription)"
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
            currentUserColor: currentUser?.profileColor ?? .accent,
            imageURL: avatar?.imageURL,
            onImagePressed: onAvatarImagePressed
          )
          .id(message.id)
        }

        if isGenerating {
          TypingIndicatorView(imageURL: avatar?.imageURL)
            .id("typing-indicator")
            .transition(.opacity)
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
    .animation(.default, value: isGenerating)
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
        }
        .padding(.trailing, 4)
        .disabled(isGenerating),
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

  private func onSendButtonTapped() {
    guard let currentUser else { return }
    let content: String
    do {
      content = try textValidator.validate(messageText)
    } catch let error as TextValidationError {
      validationError = error
      return
    } catch { return }

    messageText = ""
    Task {
      await sendMessage(content: content, by: currentUser)
    }
  }

  private func sendMessage(content: String, by currentUser: UserModel) async {
    isGenerating = true
    defer { isGenerating = false }

    do {
      let chat = try await getOrCreateChat(userId: currentUser.userId)
      let message = ChatMessageModel.newUserMessage(
        chatId: chat.id,
        userId: currentUser.userId,
        content: content
      )
      try await chatManager.addMessage(message, chatId: chat.id)
      await generateAvatarResponse(chatId: chat.id)
    } catch {
      errorMessage = "Failed to send: \(error.localizedDescription)"
    }
  }

  private func getOrCreateChat(userId: String) async throws -> ChatModel {
    if let chat { return chat }
    let new = ChatModel.new(userId: userId, avatarId: avatarId)
    try await chatManager.createChat(new)
    self.chat = new
    return new
  }

  private func generateAvatarResponse(chatId: String) async {
    guard let avatar else { return }
    let prompt = buildAIMessages(avatar: avatar)
    do {
      let reply = try await aiManager.generateText(messages: prompt)
      let response = ChatMessageModel.newAIMessage(
        chatId: chatId,
        avatarId: avatar.avatarId,
        content: reply
      )
      try? await chatManager.addMessage(response, chatId: chatId)
    } catch {
      errorMessage = "Failed to generate response: \(error.localizedDescription)"
    }
  }

  private func buildAIMessages(avatar: AvatarModel) -> [AIChatMessage] {
    let personaName = avatar.name ?? "an AI avatar"
    let persona = "You are \(personaName). \(avatar.description). Stay in character and keep replies concise and conversational."

    var messages: [AIChatMessage] = [.init(role: .system, content: persona)]
    for chat in chatMesages {
      guard let content = chat.content else { continue }
      let role: AIChatMessage.Role = (chat.authorId == currentUser?.userId) ? .user : .assistant
      messages.append(.init(role: role, content: content))
    }
    return messages
  }

  private func onSettingsButtonTapped() {
    showSettings = true
  }

  private func onReportButtonTapped() {}

  private func onAvatarImagePressed() {
    showProfileModal = true
  }
}

#Preview {
  NavigationStack {
    ChatView()
      .previewEnvironment()
  }
}
