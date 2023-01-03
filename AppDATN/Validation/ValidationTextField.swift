//
//  ValidationTextField.swift
//  AppDATN
//
//  Created by Toan Tran on 22/12/2022.
//

import Foundation

class ValidationTextField {
    func invalidEmail(_ value: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: value)
    }
    
    func invalidPassword(_ value: String) -> Bool {
        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passPred.evaluate(with: value)
    }
}
