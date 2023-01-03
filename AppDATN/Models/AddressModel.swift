//
//  AddressModel.swift
//  AppDATN
//
//  Created by Toan Tran on 25/12/2022.
//

import Foundation

struct AddressModel: Decodable {
    let _id: String?
    let name: String?
    let email: String?
    let phone: Int?
    let address: String?
    let zipcode: String?
    let city: String?
    let country: String?
}
