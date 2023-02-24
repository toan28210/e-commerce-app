//
//  CategoryItemCell.swift
//  AppDATN
//
//  Created by Toan Tran on 20/12/2022.
//

import UIKit
import Kingfisher

class CategoryItemCell: UICollectionViewCell {
    static let identifier = "CategoryItemCell"
    static func nib() -> UINib {
        return UINib(nibName: CategoryItemCell.identifier, bundle: .main)
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCollectionView(with data: CategoryModel) {
        let url = URL(string: data.img ?? "")!
        imageView.kf.setImage(with: url)
        name.text = data.nameCate ?? "Test"
    }
}
