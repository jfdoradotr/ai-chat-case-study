//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

protocol UserServices {
  var remote: any RemoteUserService { get }
  var local: any LocalUserPersistence { get }
}

struct MockUserServices: UserServices {
  let remote: any RemoteUserService
  let local: any LocalUserPersistence

  init(user: UserModel? = nil) {
    self.remote = MockUserService(user: user)
    self.local = MockUserPersistence(user: user)
  }
}

struct ProductionUserServices: UserServices {
  let remote: any RemoteUserService = FirebaseUserService()
  let local: any LocalUserPersistence = FileManagerUserPersistence()
}
