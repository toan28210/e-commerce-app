//
//  PayFooterView.swift
//  AppDATN
//
//  Created by Toan Tran on 10/02/2023.
//

import UIKit

class PayFooterView: BaseView {
    
    
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func configUI() {
        super.configUI()
    }
    
    func configure(qty: Int, total: Int) {
        price.text = "đ\(FormatNumber.shared.formatter(total: total))"
        quantity.text = "Tổng số tiền (\(qty) sản phẩm)"
    }
}
