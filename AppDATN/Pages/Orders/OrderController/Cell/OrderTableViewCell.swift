//
//  OrderTableViewCell.swift
//  AppDATN
//
//  Created by Toan Tran on 09/02/2023.
//

import UIKit
import Kingfisher

class OrderTableViewCell: UITableViewCell {
    
    static let identifier = "OrderTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: OrderTableViewCell.identifier, bundle: .main)
    }
    
    @IBOutlet weak var nameProductLabel: UILabel!
    @IBOutlet weak var amountProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var seemoreView: UIView!
    @IBOutlet weak var totalOrder: UILabel!
    @IBOutlet weak var amountOrder: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configUI(order: OrderModel) {
        let count = order.details?.count ?? 0
        amountOrder.text = "\(count) sản phẩm"
        totalOrder.text = "đ\(order.formattedPrice)"
        amountProduct.text = "x\(order.details?[0].quantity ?? 0)"
        getProduct(productId: order.details?[0].productId ?? "")
    }
    
    func getProduct(productId: String) {
        let url = URL(string: "http://localhost:5000/api/products/find/\(productId)")!
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
                    let json = try jsonDecoder.decode(ProductModel.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.nameProductLabel.text = "\(json.title ?? "")"
                        self.priceProduct.text = "đ\(json.formattedPrice)"
                        let url = URL(string: json.img ?? "")!
                        self.imageProduct.kf.setImage(with: url)
                        
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }

}
