//
//  ProductButtonCart.swift
//  AppDATN
//
//  Created by Toan Tran on 14/12/2022.
//

import UIKit

class ProductButtonCart: UIView {
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
        Bundle.main.loadNibNamed("ProductButtonCart", owner: self)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
