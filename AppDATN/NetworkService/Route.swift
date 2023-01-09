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
    
    var description: String {
        switch self {
        case .signin:
            return "/auth/login"
        }
    }
}
