//
//  Route.swift
//  AppDATN
//
//  Created by Toan Tran on 22/12/2022.
//

import Foundation

enum Route {
    static let baseUrl = "http://localhost:5000/api"
    
    case fetchCategories
    case fetchProducts
    case placeOrder(String)
    case fetchCategoryDishes(String)
    case fetchOrders
    
    var description: String {
        switch self {
        case .fetchCategories:
            return "/categories"
        case .fetchProducts:
            return "/products"
        case .placeOrder(let dishId):
            return "/orders/\(dishId)"
        case .fetchCategoryDishes(let categoryId):
            return "/dishes/\(categoryId)"
        case .fetchOrders:
            return "/orders"
        }
    }
}
