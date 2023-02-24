//
//  LoginViewModel.swift
//  AppDATN
//
//  Created by Toan Tran on 10/01/2023.
//

import Foundation
import RxCocoa
import RxSwift

final class LoginViewModel {
    enum LoginResult {
        case success
        case failure(Bool, String)
    }
    typealias Completion = (LoginResult) -> Void
    
    var email = ""
    var password = ""
    var isValidEmail: Bool {
        email.invalidEmail()
    }
    
    var isValidPassword: Bool {
        password.invalidPassword()
    }
    
    var isValdInput: Bool {
        return isValidEmail && isValidPassword
    }
    
    func loginUser(email: String, password: String, completion: @escaping(Completion)) {
        NetworkService.shared.loginUser(email: email, password: password) { result in
            switch result {
            case .success(let user):
                UserDefaults.standard.setValue(user._id, forKey: "userid")
                completion(.success)
            case .failure(let error):
                completion(.failure(true, error.localizedDescription))
            }
        }
    }
}
