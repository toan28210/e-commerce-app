//
//  CartModel.swift
//  AppDATN
//
//  Created by Toan Tran on 24/12/2022.
//

import Foundation

struct CartModel: Decodable {
    let _id: String?
    let userId: String?
    let productId: String?
    let quantity: Int?
}
