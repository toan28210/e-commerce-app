//
//  CategoryHeader.swift
//  AppDATN
//
//  Created by Toan Tran on 20/12/2022.
//

import UIKit
protocol CategoryHeaerDelegate: AnyObject {
    func seeAll()
}

class CategoryHeader: UIView {
    @IBOutlet weak var namHeaedr: UILabel!
    @IBOutlet var contentView: UIView!
    
    weak var delegate: CategoryHeaerDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    private func setupView() {
        Bundle.main.loadNibNamed("CategoryHeader", owner: self)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    @IBAction func seeAllPressed(_ sender: UIButton) {
        delegate?.seeAll()
    }
}
