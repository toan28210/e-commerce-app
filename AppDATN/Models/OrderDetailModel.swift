//
//  OrderDetailModel.swift
//  AppDATN
//
//  Created by Toan Tran on 25/12/2022.
//

import Foundation

struct OrderDetailModel: Decodable {
    let _id: String?
    let orderId: String?
    let productId: String?
    let quantity: Int?
}
