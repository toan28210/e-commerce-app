//
//  UserModel.swift
//  AppDATN
//
//  Created by Toan Tran on 22/12/2022.
//

import Foundation

struct UserModel: Decodable {
    let _id: String?
    let username: String?
    let password: String?
    let email: String?
    let avatar: String?
    let phone: Int?
    let address: String?
    let isAdmin: Bool?
    let createdAt: String?
    let updateAt: String?
    let __v: Int?
    let accessToken: String?
}
