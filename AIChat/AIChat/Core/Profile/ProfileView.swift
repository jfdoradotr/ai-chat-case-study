//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
  @State private var showSettingsView = false
  @State private var showCreateAvatar = false
  @State private var currentUser: UserModel? = .preview
  @State private var myAvatars: [AvatarModel] = .preview

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

      Section  {
        ForEach(myAvatars) { avatar in
          CustomListCellView(
            imageURL: avatar.imageURL,
            title: avatar.name,
            subtitle: nil
          )
        }
        .onDelete(perform: onDeleteAvatar)
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
      Text("Create Avatar")
    }
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
  }
}
