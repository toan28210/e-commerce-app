//
//  String + Extension.swift
//  AppDATN
//
//  Created by Toan Tran on 10/01/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension String {
    func invalidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func invalidPassword() -> Bool {
        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passPred.evaluate(with: self)
    }
}

extension UIButton {
  public func driver() -> Driver<Void> {
    return rx.tap.asDriver()
  }
}
