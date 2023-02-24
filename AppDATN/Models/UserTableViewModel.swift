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
            UserTableViewModel(icon: "img-about-image", title: "Thiết lập tài khoản"),
            UserTableViewModel(icon: "img-myOder-image", title: "Lịch sử mua hàng"),
            UserTableViewModel(icon: "ima-myFav-image", title: "Đã thích"),
            UserTableViewModel(icon: "img-tran-image", title: "Giao dịch"),
            UserTableViewModel(icon: "img-noti-image", title: "Thông báo"),
            UserTableViewModel(icon: "img-signout-image", title: "Sign out"),
        ]
    }
}
