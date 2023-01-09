//
//  FormatNumber.swift
//  AppDATN
//
//  Created by Toan Tran on 06/01/2023.
//

import Foundation

class FormatNumber {
    static let shared = FormatNumber()
    private init() {}
    
    func formatter(total: Int) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        return formatter.string(for: total) ?? ""
    }
}
