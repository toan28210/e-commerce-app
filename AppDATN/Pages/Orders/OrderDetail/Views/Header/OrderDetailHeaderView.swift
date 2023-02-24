//
//  OrderDetailHeaderView.swift
//  AppDATN
//
//  Created by Toan Tran on 09/02/2023.
//

import UIKit

class OrderDetailHeaderView: BaseView {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    override func configUI() {
        super.configUI()
    }
    
    func updateUI(address: AddressModel) {
        nameLabel.text = address.name ?? ""
        phoneNumber.text = "(+84) \(address.phone ?? 0)"
        addressLabel.text = "\(address.addressStreet ?? ""), \(address.address ?? "")"
    }

}
