//
//  AddressView.swift
//  AppDATN
//
//  Created by Toan Tran on 25/12/2022.
//

import UIKit

class AddressView: UIView {
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    private func setupView() {
        Bundle.main.loadNibNamed("AddressView", owner: self)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
