//
//  CustomHomeHeaderView.swift
//  AppDATN
//
//  Created by Toan Tran on 21/02/2023.
//

import UIKit

class CustomHomeHeaderView: UICollectionReusableView {
    static let identifier = "CustomHomeHeaderView"
    let contentView: HomeHeaderView = {
        let superView = HomeHeaderView()
        return superView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
        setupConstraints()
    }

    private func setupView() {
        self.addSubview(contentView)
    }

    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
