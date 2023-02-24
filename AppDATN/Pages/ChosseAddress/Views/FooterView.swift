//
//  FooterView.swift
//  AppDATN
//
//

import UIKit

protocol FooterViewDelegate: AnyObject {
    func addAddress()
}

class FooterView: BaseView {
    
    @IBOutlet weak var addAddress: UIButton!
    weak var delegate: FooterViewDelegate?
    
    override func configUI() {
        super.configUI()
    }
    
    @IBAction func addAddressPressed(_ sender: UIButton) {
        delegate?.addAddress()
    }
    
}
