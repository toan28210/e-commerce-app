//
//  OrderDetailTableViewCell.swift
//  AppDATN
//
//  Created by Toan Tran on 09/02/2023.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {
    
    static let identifier = "OrderDetailTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: OrderDetailTableViewCell.identifier, bundle: .main)
    }

    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var quantityProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configUI(orderDetail: OrderDetailModel) {
        quantityProduct.text = "x\(orderDetail.quantity ?? 0)"
        getProduct(productId: orderDetail.productId ?? "")
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
                        self.nameProduct.text = "\(json.title ?? "")"
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
