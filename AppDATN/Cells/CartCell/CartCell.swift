//
//  CartCell.swift
//  AppDATN
//
//  Created by Toan Tran on 06/12/2022.
//

import UIKit
protocol CartCellDelegate: AnyObject {
    func updateItemCart(qty: Int, cartId: String)
    func subTotal(qty: Int, price: Int)
}

class CartCell: UITableViewCell {
    @IBOutlet weak var cartMass: UILabel!
    @IBOutlet weak var cartName: UILabel!
    @IBOutlet weak var cartPrice: UILabel!
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var amoutLanbel: UILabel!
    weak var delegate: CartCellDelegate?
    static let identifier = "CartCell"
    static func nib() -> UINib {
        return UINib(nibName: CartCell.identifier, bundle: .main)
    }
    var qty = 0
    var cartId = ""
    lazy var subTotal = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func amoutPressed(_ sender: UIButton) {
        print("update")
        if sender.tag == 0 {
            qty += 1
        } else {
            qty -= 1
        }
        self.delegate?.updateItemCart(qty: qty, cartId: cartId)
    }
}

extension CartCell {
    func fetchProductCart(id: String) {
        let url = URL(string: "http://localhost:5000/api/products/find/\(id)")!
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
                    print("price: \(json.price ?? 0)")
                    DispatchQueue.main.sync {
                        self.cartName.text = json.title
                        self.cartPrice.text = "\(json.formattedPrice) VND * \(self.qty)"
                        self.amoutLanbel.text = "\(self.qty)"
                        let url = URL(string: json.img ?? "")
                        self.cartImage.kf.setImage(with: url)
                        self.delegate?.subTotal(qty: self.qty, price: json.price ?? 0)
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}
