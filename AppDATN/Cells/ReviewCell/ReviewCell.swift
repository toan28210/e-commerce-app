//
//  ReviewCell.swift
//  AppDATN
//
//  Created by Toan Tran on 24/12/2022.
//

import UIKit
import Cosmos

class ReviewCell: UICollectionViewCell {

    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var resTextView: UITextView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var rating: UILabel!
    static let identifier = "ReviewCell"
    static func nib() -> UINib {
        return UINib(nibName: ReviewCell.identifier, bundle: .main)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.addTopAndBottomBorders()
        resTextView.isEditable = false
        imageView.layer.cornerRadius = imageView.frame.width/2
    }
    func configure(with data: RatingModel) {
        rating.text = String(format: "%.1f", data.rating ?? 0)
        cosmosView.rating = data.rating ?? 0
        resTextView.text = data.response ?? ""
        fetchDataUser(userId: data.userId ?? "")
    }
    
    func fetchDataUser(userId: String) {
        let url = URL(string: "http://localhost:5000/api/users/find/\(userId)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
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
                    let json = try jsonDecoder.decode(UserModel.self, from: data)
                    print(json)
                    DispatchQueue.main.async {
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }

}
