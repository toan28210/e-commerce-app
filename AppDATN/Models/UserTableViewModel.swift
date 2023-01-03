//
//  UserTableViewModel.swift
//  AppDATN
//
//  Created by Toan Tran on 21/12/2022.
//

import Foundation

struct UserTableViewModel {
    let icon: String
    let title: String
}

class UserTableViewService {
    static let shared = UserTableViewService()
    func getDatas() -> [UserTableViewModel] {
        return [
            UserTableViewModel(icon: "img-about-image", title: "Abount me"),
            UserTableViewModel(icon: "img-myOder-image", title: "My orders"),
            UserTableViewModel(icon: "ima-myFav-image", title: "My Favorites"),
            UserTableViewModel(icon: "img-address-image", title: "My Address"),
            UserTableViewModel(icon: "img-cre-image", title: "Credit Cards"),
            UserTableViewModel(icon: "img-tran-image", title: "Transactions"),
            UserTableViewModel(icon: "img-noti-image", title: "Notifications"),
            UserTableViewModel(icon: "img-signout-image", title: "Sign out"),
        ]
    }
}
