//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(AvatarManager.self) private var avatarManager
  @Environment(AIManager.self) private var aiManager
  @Environment(ChatManager.self) private var chatManager
  @Environment(UserManager.self) private var userManager
  @Environment(LogManager.self) private var logManager

  @State private var chatMesages: [ChatMessageModel] = []
  @State private var chat: ChatModel?
  @State private var avatar: AvatarModel?
  @State private var messageText: String = ""
  @State private var showSettings = false
  @State private var scrollPosition: String?
  @State private var validationError: TextValidationError?
  @State private var showProfileModal = false
  @State private var errorMessage: String?
  @State private var isGenerating = false

  private let textValidator = TextValidator()
  private var currentUser: UserModel? { userManager.currentUser }
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
      Button("View Avatar Profile", action: onAvatarImagePressed)
      Button("Delete Chat", role: .destructive, action: onDeleteChatPressed)
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
    .trackScreen(ScreenEvent.chat)
  }
}

private extension ChatView {
  func loadAvatar() async {
    logManager.trackEvent(event: ChatEvent.loadAvatarStart)
    do {
      let loaded = try await avatarManager.getAvatar(id: avatarId)
      self.avatar = loaded
      logManager.trackEvent(event: ChatEvent.loadAvatarSuccess(avatarId: loaded.avatarId))
      try? await avatarManager.addRecentAvatar(loaded)
    } catch {
      errorMessage = "Failed to load avatar: \(error.localizedDescription)"
      logManager.trackEvent(event: ChatEvent.loadAvatarFailure(error: error))
    }
  }

  func loadExistingChat() async {
    guard let userId = currentUser?.userId else { return }
    logManager.trackEvent(event: ChatEvent.loadChatStart)
    do {
      guard let existing = try await chatManager.getChat(userId: userId, avatarId: avatarId) else {
        logManager.trackEvent(event: ChatEvent.loadChatSuccess(chat: nil))
        return
      }
      self.chat = existing
      logManager.trackEvent(event: ChatEvent.loadChatSuccess(chat: existing))
    } catch {
      errorMessage = "Failed to load chat: \(error.localizedDescription)"
      logManager.trackEvent(event: ChatEvent.loadChatFailure(error: error))
    }
  }

  func listenToMessages(chatId: String) async {
    logManager.trackEvent(event: ChatEvent.messagesListenStart(chatId: chatId))
    do {
      for try await messages in chatManager.streamMessages(forChatId: chatId) {
        self.chatMesages = messages
      }
    } catch {
      errorMessage = "Lost connection to chat: \(error.localizedDescription)"
      logManager.trackEvent(event: ChatEvent.messagesListenFailure(error: error))
    }
  }

  var scrollViewSection: some View {
    ScrollView {
      LazyVStack(spacing: 24) {
        ForEach(groupedMessages, id: \.day) { group in
          ChatDayHeaderView(date: group.day)
            .padding(.top, 8)
          ForEach(group.messages) { message in
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

  var groupedMessages: [(day: Date, messages: [ChatMessageModel])] {
    let calendar = Calendar.current
    var groups: [(day: Date, messages: [ChatMessageModel])] = []
    for message in chatMesages {
      let date = message.dateCreated ?? .now
      let day = calendar.startOfDay(for: date)
      if let last = groups.last, calendar.isDate(last.day, inSameDayAs: day) {
        groups[groups.count - 1].messages.append(message)
      } else {
        groups.append((day: day, messages: [message]))
      }
    }
    return groups
  }

  var textFieldSection: some View {
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

  func onSendButtonTapped() {
    logManager.trackEvent(event: ChatEvent.sendMessagePressed)
    guard let currentUser else { return }
    let content: String
    do {
      content = try textValidator.validate(messageText)
    } catch let error as TextValidationError {
      validationError = error
      logManager.trackEvent(event: ChatEvent.sendMessageValidationFailure(error: error))
      return
    } catch {
      logManager.trackEvent(event: ChatEvent.sendMessageValidationFailure(error: error))
      return
    }

    messageText = ""
    Task {
      await sendMessage(content: content, by: currentUser)
    }
  }

  func sendMessage(content: String, by currentUser: UserModel) async {
    isGenerating = true
    defer { isGenerating = false }

    do {
      let chat = try await getOrCreateChat(userId: currentUser.userId)
      let message = ChatMessageModel.newUserMessage(
        chatId: chat.id,
        userId: currentUser.userId,
        content: content
      )
      logManager.trackEvent(event: ChatEvent.sendMessageStart(chat: chat, message: message))
      chatMesages.append(message)
      scrollPosition = message.id
      try await chatManager.addMessage(message, chatId: chat.id)
      logManager.trackEvent(event: ChatEvent.sendMessageSuccess(chat: chat, message: message))
      await generateAvatarResponse(chat: chat)
    } catch {
      errorMessage = "Failed to send: \(error.localizedDescription)"
      logManager.trackEvent(event: ChatEvent.sendMessageFailure(error: error))
    }
  }

  func getOrCreateChat(userId: String) async throws -> ChatModel {
    if let chat { return chat }
    let new = ChatModel.new(userId: userId, avatarId: avatarId)
    try await chatManager.createChat(new)
    self.chat = new
    return new
  }

  func generateAvatarResponse(chat: ChatModel) async {
    guard let avatar else { return }
    let prompt = buildAIMessages(avatar: avatar)
    logManager.trackEvent(event: ChatEvent.generateResponseStart(chat: chat))
    do {
      let reply = try await aiManager.generateText(messages: prompt)
      let response = ChatMessageModel.newAIMessage(
        chatId: chat.id,
        avatarId: avatar.avatarId,
        content: reply
      )
      chatMesages.append(response)
      scrollPosition = response.id
      try? await chatManager.addMessage(response, chatId: chat.id)
      logManager.trackEvent(event: ChatEvent.generateResponseSuccess(chat: chat, message: response))
    } catch {
      errorMessage = "Failed to generate response: \(error.localizedDescription)"
      logManager.trackEvent(event: ChatEvent.generateResponseFailure(error: error))
    }
  }

  func buildAIMessages(avatar: AvatarModel) -> [AIChatMessage] {
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

  func onSettingsButtonTapped() {
    showSettings = true
  }

  func onDeleteChatPressed() {
    logManager.trackEvent(event: ChatEvent.deleteChatPressed(chat: chat))
    guard let chat else {
      dismiss()
      return
    }
    Task {
      do {
        try await chatManager.deleteChat(chatId: chat.id)
        logManager.trackEvent(event: ChatEvent.deleteChatSuccess(chat: chat))
        dismiss()
      } catch {
        errorMessage = "Failed to delete chat: \(error.localizedDescription)"
        logManager.trackEvent(event: ChatEvent.deleteChatFailure(error: error))
      }
    }
  }

  func onAvatarImagePressed() {
    logManager.trackEvent(event: ChatEvent.avatarImagePressed(avatarId: avatar?.avatarId))
    showProfileModal = true
  }
}

#Preview {
  NavigationStack {
    ChatView()
      .previewEnvironment()
  }
}
