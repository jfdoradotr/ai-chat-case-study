//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
  @Environment(UserManager.self) private var userManager
  @Environment(AvatarManager.self) private var avatarManager

  @State private var showSettingsView = false
  @State private var showCreateAvatar = false
  @State private var currentUser: UserModel? = .preview
  @State private var myAvatars: [AvatarModel] = []
  @State private var isLoading = true
  @State private var errorMessage: String?

  var body: some View {
    List {
      Section {
        ZStack {
          Circle()
            .fill(currentUser?.profileColor ?? .accent)
        }
        .frame(width: 100, height: 100)
        .frame(maxWidth: .infinity)
      }
      .listRowInsets(EdgeInsets())
      .listRowBackground(Color.clear)

      Section {
        if myAvatars.isEmpty {
          Group {
            if isLoading {
              ProgressView()
            } else {
              Text("Click + to create an avatar")
            }
          }
          .listRowInsets(EdgeInsets())
          .listRowBackground(Color.clear)
          .frame(height: 150)
          .frame(maxWidth: .infinity)
          .foregroundStyle(.secondary)
        } else {
          ForEach(myAvatars) { avatar in
            NavigationLink(value: avatar.avatarId) {
              CustomListCellView(
                imageURL: avatar.imageURL,
                title: avatar.name,
                subtitle: nil
              )
            }
          }
          .onDelete(perform: onDeleteAvatar)
        }
      } header: {
        HStack(spacing: 0) {
          Text("My avatars")
          Spacer()
          Button("Create avatar", systemImage: "plus.circle.fill", action: onNewAvatarButtonPressed)
            .labelStyle(.iconOnly)
            .buttonStyle(.borderless)
            .font(.title2)
        }
      }
    }
    .navigationTitle("Profile")
    .navigationDestination(for: String.self) { avatarId in
      ChatView(avatarId: avatarId)
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button(
          "Settings",
          systemImage: "gear",
          action: onSettingsButtonPressed
        )
      }
    }
    .sheet(isPresented: $showSettingsView) {
      NavigationStack {
        SettingsView()
      }
    }
    .fullScreenCover(isPresented: $showCreateAvatar) {
      NavigationStack {
        CreateAvatarView()
      }
    }
    .task {
      await loadData()
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
  }

  private func loadData() async {
    self.currentUser = userManager.currentUser

    guard let userId = currentUser?.userId else {
      isLoading = false
      return
    }

    do {
      myAvatars = try await avatarManager.getAvatars(forAuthorId: userId)
    } catch {
      errorMessage = "Failed to load your avatars: \(error.localizedDescription)"
    }
    isLoading = false
  }

  private func onSettingsButtonPressed() {
    showSettingsView = true
  }

  private func onNewAvatarButtonPressed() {
    showCreateAvatar = true
  }
  private func onDeleteAvatar(_ indexSet: IndexSet) {
    myAvatars.remove(atOffsets: indexSet)
  }
}

#Preview {
  NavigationStack {
    ProfileView()
      .environment(AppState())
      .environment(UserManager(services: MockUserServices(user: .preview)))
      .environment(AvatarManager(services: MockAvatarServices()))
  }
}
