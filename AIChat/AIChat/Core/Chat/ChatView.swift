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
  @State private var validationError: TextValidationError?
  @State private var showProfileModal = false

  private let textValidator = TextValidator()

  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        scrollViewSection
        textFieldSection
      }

      ZStack {
        if showProfileModal {
          Color.black.opacity(0.6)
            .ignoresSafeArea()
            .transition(AnyTransition.opacity.animation(.smooth))
            .onTapGesture {
              showProfileModal = false
            }

          if let avatar {
            ProfileModalView {
              showProfileModal = false
            }
            .padding(40)
            .transition(.slide)
          }
        }
      }
      .zIndex(9999)
    }
    .animation(.bouncy, value: showProfileModal)
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
            imageURL: avatar?.imageURL,
            onImagePressed: onAvatarImagePressed
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

  private func onSendButtonTapped() {
    guard let currentUser else { return }
    let content: String
    do {
      content = try textValidator.validate(messageText)
    } catch let error as TextValidationError {
      validationError = error
      return
    } catch { return }
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

  private func onAvatarImagePressed() {
    showProfileModal = true
  }
}

#Preview {
  NavigationStack {
    ChatView()
  }
}
