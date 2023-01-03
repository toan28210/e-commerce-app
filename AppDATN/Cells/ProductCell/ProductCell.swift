//
//  ProductCell.swift
//  AppDATN
//
//  Created by Toan Tran on 13/12/2022.
//

import UIKit
import Kingfisher

class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    static func nib() -> UINib {
        return UINib(nibName: ProductCell.identifier, bundle: .main)
    }
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var bottomProductCardView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with data: ProductModel) {
        let url = URL(string: data.img ?? "")!
        productImage.kf.setImage(with: url)
        productPrice.text = "\(data.price ?? 0) VND"
        productName.text = data.title ?? ""
    }

}
