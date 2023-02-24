//
//  OrderDetailFooterView.swift
//  AppDATN
//
//  Created by Toan Tran on 10/02/2023.
//

import UIKit

class OrderDetailFooterView: BaseView {

    @IBOutlet weak var priceOrder: UILabel!
    
    override func configUI() {
        super.configUI()
    }
    
    func config(order: OrderModel) {
        priceOrder.text = "đ\(order.formattedPrice)"
    }
}
