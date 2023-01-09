//
//  APIResponse.swift
//  AppDATN
//
//  Created by Toan Tran on 06/01/2023.
//

import Foundation
struct ApiResponse<T: Decodable>: Decodable {
    let status: Int
    let message: String?
    let data: T?
    let error: String?
}
