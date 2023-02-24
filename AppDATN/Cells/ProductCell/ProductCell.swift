//
//  ProductCell.swift
//  AppDATN
//
//  Created by Toan Tran on 13/12/2022.
//

import UIKit
import Kingfisher

class ProductCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var bottomProductCardView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    var isSelect = false
    
    static let identifier = "ProductCell"
    static func nib() -> UINib {
        return UINib(nibName: ProductCell.identifier, bundle: .main)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        customLikeButton()
    }
    
    func configure(with data: ProductModel) {
        let url = URL(string: data.img ?? "")!
        productImage.kf.setImage(with: url)
        productPrice.text = "\(data.formattedPrice) VND"
        productName.text = data.title ?? ""
        let userId = "\(UserDefaults.standard.value(forKey: "userid") ?? "")"
        checkUserLike(userId: userId, productId: data._id ?? "")
    }
    
    func checkUserLike(userId: String, productId: String) {
        let url = URL(string: "http://localhost:5000/api/like/findOne")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let params = [
            "userId": userId,
            "productId": productId
        ]
        let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.httpBody = bodyData
        let task = URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil || data == nil {
                    print("Client error!")
                    return
                }
                guard let response = res as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error!")
                    return
                }
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    return
                }
                do {
                    guard let data = data else {
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    let _ = try jsonDecoder.decode(LikeModel.self, from: data)
                    DispatchQueue.main.async {
//                        self.isSelect = true
//                        self.likeButton.isSelected = true
//                        self.updateButtonLikeUI()
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }


    func updateButtonLikeUI() {
        if self.isSelect {
            self.likeButton.tintColor = .systemPink
        } else {
            self.likeButton.tintColor = .gray
        }
    }
    func customLikeButton() {
        self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }
}
