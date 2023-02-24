//
//  PayHeaderView.swift
//  AppDATN
//
//

import UIKit

protocol ChooseHeaerDelegate: AnyObject {
    func pushView()
}

class PayHeaderView: BaseView {

    @IBOutlet weak var nameAndPhone: UILabel!
    @IBOutlet weak var chosseAddress: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    weak var delegate: ChooseHeaerDelegate?
    override func configUI() {
        super.configUI()
    }
    
    func updateUI(address: AddressModel) {
        nameAndPhone.text = "\(address.name ?? "") | (+84)\(address.phone ?? 0)"
        addressLabel.text = "\(address.addressStreet ?? ""), \(address.address ?? "")"
    }
    
    @IBAction func chosseAddressPressed(_ sender: UIButton) {
        delegate?.pushView()
    }
    
    @IBAction func testPressed(_ sender: UIButton) {
        delegate?.pushView()
    }
    
}
