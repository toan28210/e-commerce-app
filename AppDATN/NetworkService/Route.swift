//
//  Route.swift
//  AppDATN
//
//  Created by Toan Tran on 22/12/2022.
//

import Foundation

enum Route {
    static let baseUrl = "http://localhost:5000/api"
    
    case signin
    case getUser(String)
    case getAllProduct
    case checkLike
    case addCard
    case checkProductToCart
    case like
    case unlike(String)
    case updateLikeProduct(String)
    case checkOut
    case getDataCart(String)
    case addOrderDetail
    
    var description: String {
        switch self {
        case .signin:
            return "/auth/login"
        case .getUser(let userId):
            return "/auth/find/\(userId)"
        case .getAllProduct:
            return "/products"
        case .checkLike:
            return "/like/findOne"
        case .addCard:
            return "/cart/"
        case .checkProductToCart:
            return "/cart/check"
        case .like:
            return "/like"
        case .unlike(let likeId):
            return "/like/\(likeId)"
        case .updateLikeProduct(let productId):
            return "/products/\(productId)"
        case .checkOut:
            return "/orders"
        case .getDataCart(let userId):
            return "/cart/find/\(userId)"
        case .addOrderDetail:
            return "/orderdetails"
        }
    }
}
