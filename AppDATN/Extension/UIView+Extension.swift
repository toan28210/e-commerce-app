//
//  UIView_Extendtion.swift
//  AppDATN
//
//  Created by Toan Tran on 12/12/2022.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        } set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWith: CGFloat {
        get {
            return self.borderWith
        } set {
            self.layer.borderWidth = newValue
        }
    }
}
extension UIView {
    func addTopAndBottomBorders() {
        let thickness: CGFloat = 0.4
       let bottomBorder = CALayer()
       bottomBorder.frame = CGRect(x:0, y: self.frame.size.height - thickness, width: self.frame.size.width, height: thickness)
       bottomBorder.backgroundColor = UIColor.systemGray2.cgColor
       self.layer.addSublayer(bottomBorder)
    }
}

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
}
