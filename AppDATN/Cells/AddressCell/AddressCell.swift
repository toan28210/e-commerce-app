//
//  AddressCell.swift
//  AppDATN
//
//  Created by Toan Tran on 25/12/2022.
//

import UIKit
protocol AddressCellDelegate: AnyObject {
    func reload()
}

class AddressCell: UICollectionViewCell {
    
    @IBOutlet weak var showEditAddress: UIButton!
    @IBOutlet weak var formEditAddress: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    weak var delegate: AddressCellDelegate?
    static let identifier = "AddressCell"
    static func nib() -> UINib {
        return UINib(nibName: AddressCell.identifier, bundle: .main)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(item: AddressModel) {
        name.text = item.name ?? ""
        address.text = item.address ?? ""
        phone.text = "+84 \(item.phone ?? 0)"
    }

    @IBAction func showEditPressed(_ sender: UIButton) {
        formEditAddress.backgroundColor = .red
//        self.frame.size.height = 500
        self.delegate?.reload()
    }
}
