//
//  StartCell.swift
//  AppDATN
//
//  Created by Toan Tran on 05/12/2022.
//

import UIKit

class StartCell: UICollectionViewCell {
    static let identifier = "StartCell"
    static func nib() -> UINib {
        return UINib(nibName: StartCell.identifier, bundle: .main)
    }
    @IBOutlet weak var startDesLabel: UILabel!
    @IBOutlet private weak var startImageView: UIImageView!
    @IBOutlet weak var startTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
// MARK: - Configure Start Cell
extension StartCell {
    func configure(with item: StartModels) {
        startImageView.image = UIImage(named: item.startImage)
        startTitleLabel.text = item.startTitle
        startDesLabel.text = item.startDes
    }
}
