//
//  BaseView.swift
//  AppDATN
//
//  Created by Toan Tran on 09/02/2023.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class BaseView: UIView {
    // MARK: - Properties
    var contentView: UIView?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    func setup() {
        guard let contentView = contentFromXib() else { return }
        self.contentView = contentView
        configUI()
        setupAction()
        bindingData()
    }
    
    func configUI() {}
    func bindingData() {}
    func setupAction() {}
}


public extension UIView {
    static var loadNib: UINib {
        return UINib(nibName: "\(self)", bundle: nil)
    }
    
    func contentFromXib() -> UIView? {
        
        guard let contentView = type(of: self).loadNib.instantiate(withOwner: self, options: nil).last as? UIView else {
            return nil
        }
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
        
        return contentView
    }
}
