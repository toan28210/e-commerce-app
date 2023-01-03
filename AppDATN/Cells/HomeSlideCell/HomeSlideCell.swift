//
//  HomeSlideCell.swift
//  AppDATN
//
//  Created by Toan Tran on 05/12/2022.
//

import UIKit

class HomeSlideCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    static let identifier = "HomeSlideCell"
    static func nib() -> UINib {
        return UINib(nibName: HomeSlideCell.identifier, bundle: .main)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView(with data: SlideModel) {
        imageView.image = UIImage(named: data.image)
    }

}
