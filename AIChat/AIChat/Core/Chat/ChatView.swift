//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatView: View {
  @State private var chatMesages: [ChatMessageModel] = .preview
  @State private var avatar: AvatarModel? = .preview
  @State private var currentUser: UserModel? = .preview
  @State private var messageText: String = ""
  @State private var showSettings = false
  @State private var scrollPosition: String?
  @State private var showAlert = false

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

  private func checkIfMessageIsValid() -> Bool {
    !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  private func onSendButtonTapped() {
    guard checkIfMessageIsValid(), let currentUser else { return }
    let content = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
    if checkIfMessageIsValid() {
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
    } else {

    }
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
