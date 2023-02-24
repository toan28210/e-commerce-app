//
//  OrderModel.swift
//  AppDATN
//
//  Created by Toan Tran on 25/12/2022.
//

import Foundation

struct OrderModel: Decodable {
    let _id: String?
    let userId: String?
    let amount: Int?
    let status: String?
    var details : [OrderDetailModel]?
    let address: String?
    var formattedPrice: String {
        return "\(FormatNumber.shared.formatter(total: amount ?? 0))"
    }
}
