//
//  ChosseAddressTableViewCell.swift
//  AppDATN
//
//  Created by Toan Tran on 19/02/2023.
//

import UIKit
protocol ChosseAddressTableViewCellDelegate: AnyObject {
    func chosseAddress()
    func updateAddressPressed()
}

class ChosseAddressTableViewCell: UITableViewCell {
    static let identifier = "ChosseAddressTableViewCell"
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var duongLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var updateAddress: UIButton!
    private weak var delegate: ChosseAddressTableViewCellDelegate?
    static func nib() -> UINib {
        return UINib(nibName: ChosseAddressTableViewCell.identifier, bundle: .main)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configUI(item: AddressModel) {
        nameLabel.text = item.name ?? ""
        phoneLabel.text = "(+84) \(item.phone ?? 0)"
        duongLabel.text = item.addressStreet ?? ""
        addressLabel.text = item.address ?? ""
        radioButton.isSelected = item.isdefault ?? false
        let isDefault = item.isdefault ?? false
        statusView.isHidden = !isDefault
        
    }
    
    @IBAction func updateAddressPressed(_ sender: UIButton) {
        delegate?.updateAddressPressed()
    }
    @IBAction func radioPressed(_ sender: UIButton) {
        radioButton.isSelected = !radioButton.isSelected
    }
}
