//
//  SearchCell.swift
//  AppDATN
//
//  Created by Toan Tran on 23/12/2022.
//

import UIKit

class SearchCell: UICollectionViewCell {
    @IBOutlet weak var titleSearch: UILabel!
    static let identifier = "SearchCell"
    static func nib() -> UINib {
        return UINib(nibName: SearchCell.identifier, bundle: .main)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
