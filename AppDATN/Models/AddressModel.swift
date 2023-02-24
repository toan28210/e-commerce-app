//
//  AddressModel.swift
//  AppDATN
//
//  Created by Toan Tran on 25/12/2022.
//

import Foundation

struct AddressModel: Decodable {
    let _id: String?
    let userId: String?
    let name: String?
    let phone: Int?
    let addressStreet: String?
    let address: String?
    let isdefault: Bool?
}
