//
//  AddRCell.swift
//  AppDATN
//
//  Created by Toan Tran on 26/12/2022.
//

import UIKit
protocol AddRCellDelegate: AnyObject {
    func reload()
}

class AddRCell: UITableViewCell {
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var addressView: UIStackView!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var AddressLb: UILabel!
    @IBOutlet weak var phoneLb: UILabel!
    @IBOutlet weak var nameTxt: CustomTextField!
    @IBOutlet weak var AddressTxt: CustomTextField!
    @IBOutlet weak var cityTxt: CustomTextField!
    @IBOutlet weak var zipcodeTxt: CustomTextField!
    @IBOutlet weak var countryTxt: CustomTextField!
    @IBOutlet weak var phoneTxt: CustomTextField!
    weak var addressViewController: AddressViewController?
    weak var delegate: AddressCellDelegate?
    static let identifier = "AddRCell"
    static func nib() -> UINib {
        return UINib(nibName: AddRCell.identifier, bundle: .main)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setImageBtn()
        formView.isHidden = true
        self.addressViewController?.addressTableView.beginUpdates()
        self.addressViewController?.addressTableView.endUpdates()
    }
    func initializeViewController(addressViewController:AddressViewController) {
        self.addressViewController = addressViewController
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setImageBtn() {
        showButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        showButton.setImage(UIImage(systemName: "arrow.up.circle"), for: .selected)
    }
    func configureView(address: AddressModel) {
        nameLb.text = address.name ?? ""
        AddressLb.text = address.address
        phoneLb.text = "\(address.phone ?? 0)"
        nameTxt.text = address.name ?? ""
        AddressTxt.text = address.address ?? ""
        cityTxt.text = address.city ?? ""
        countryTxt.text = address.country ?? ""
        zipcodeTxt.text = address.zipcode ?? ""
        phoneTxt.text = "\(address.phone ?? 0)"
    }
    
    @IBAction func showFormPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            formView.isHidden = false
        } else {
            formView.isHidden = true
        }
        self.addressViewController?.addressTableView.beginUpdates()
        self.addressViewController?.addressTableView.endUpdates()
        self.delegate?.reload()
    }
}
