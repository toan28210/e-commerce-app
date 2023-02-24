//
//  RatingModel.swift
//  AppDATN
//
//  Created by Toan Tran on 24/12/2022.
//

import Foundation

struct RatingModel: Decodable {
    let _id: String?
    let userId: String?
    let productId: String?
    let rating: Double?
    let response: String?
    let createdAt: String?
}
