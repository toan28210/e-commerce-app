//
//  UserCell.swift
//  AppDATN
//
//  Created by Toan Tran on 21/12/2022.
//

import UIKit

class UserCell: UITableViewCell {
    static let identifier = "UserCell"
    static func nib() -> UINib {
        return UINib(nibName: UserCell.identifier, bundle: .main)
    }

    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with data: UserTableViewModel) {
        titleLabel.text = data.title
        iconImageView.image = UIImage(named: data.icon)
        if data.title == "Sign out" {
            arrowButton.isHidden = true
        }
    }
    
}
