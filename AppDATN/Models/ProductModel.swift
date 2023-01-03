//
//  ProductModel.swift
//  AppDATN
//
//  Created by Toan Tran on 22/12/2022.
//

import Foundation

struct ProductModel: Decodable {
    let _id: String?
    let title: String?
    let desc: String?
    let img: String?
    let amount: Int?
    let sold: Int?
    let like: Int?
    let rating: Int?
    let reviewscore: Double?
    let categories: [String]?
    let size: [String]?
    let color: [String]?
    let price: Int?
    let inStock: Bool?
    let createdAt: String?
    let updatedAt: String?
    let __v: Int?
}

struct Products: Decodable {
    let productId: String
    let quantity: Int
}
