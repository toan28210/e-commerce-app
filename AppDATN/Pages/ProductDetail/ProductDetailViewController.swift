//
//  ProductDetailViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 06/12/2022.
//

import UIKit
import Kingfisher
import Cosmos
class ProductDetailViewController: UIViewController {
    @IBOutlet private weak var detailImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet weak var infoDetailView: UIView!
    @IBOutlet weak var amoutLabel: UILabel!
    @IBOutlet weak private var priceDetail: UILabel!
    @IBOutlet weak private var nameProduct: UILabel!
    @IBOutlet weak private var descProduct: UILabel!
    @IBOutlet weak private var viewCart: UIButton!
    @IBOutlet weak private var addCartButton: UIView!
    @IBOutlet weak private var reviewLb: UILabel!
    @IBOutlet weak private var ratingLb: UILabel!
    @IBOutlet weak private var cosmosView: CosmosView!
    var amount = 1
    var likeId = ""
    lazy var rating = 0.0
    var reviews: [RatingModel] = []
    var product: ProductModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTabbar()
        descTextView()
        configure()
        customLikeButton()
        checkProductToCart()
    }
    func setupNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .black
    }
    func setupTabbar() {
        tabBarController?.tabBar.isHidden = true
    }
    func descTextView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(nextPage))
        reviewLb.isUserInteractionEnabled = true
        reviewLb.addGestureRecognizer(tap)
        reviewLb.text = "(\(product.rating ?? 0) reviews)"
        let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 11.0)
        let readmoreFontColor = UIColor.blue
        DispatchQueue.main.async {
            self.descProduct.addTrailing(with: "... ", moreText: "Readmore", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
        }
    }
    func customLikeButton() {
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        checkUserLike()
    }
    @objc func nextPage() {
        let reviews = ReviewViewController()
        reviews.productId = product._id ?? ""
        self.navigationController?.pushViewController(reviews, animated: true)
    }
    @IBAction func viewCartPressed(_ sender: UIButton) {
        let cart = CartViewController()
        navigationController?.pushViewController(cart, animated: true)
    }
    func checkUserLike() {
        let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
        let productId = product._id ?? ""
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
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        let json = try jsonDecoder.decode(LikeModel.self, from: data)
                        print(json)
                        self.likeId = json._id ?? ""
                        DispatchQueue.main.async {
                            self.likeButton.isSelected = true
                            self.checkButtonLike()
                        }
                    }
                } catch {
                    print(123123123)
                }
        }
        task.resume()
    }
    @IBAction func likePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
            let productId = product._id ?? ""
            let url = URL(string: "http://localhost:5000/api/like")!
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
                        let json = try jsonDecoder.decode(LikeModel.self, from: data)
                        self.likeId = json._id ?? ""
                        self.updateLikeProduct(like: 1 + (self.product.like ?? 0))

                    } catch {
                        print("JSON error: \(error.localizedDescription)")
                    }
            }
            task.resume()
        } else {
            let url = URL(string: "http://localhost:5000/api/like/\(likeId)")!
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "DELETE"
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
                if let _ = data {
                    self.updateLikeProduct(like: (self.product.like ?? 0) - 1)
                }
            }
            task.resume()
        }
    }
    func updateLikeProduct(like: Int) {
        let productId = product._id ?? ""
        let url = URL(string: "http://localhost:5000/api/products/\(productId)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        let params: [String: Any] = [
            "like": like
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
                    let json = try jsonDecoder.decode(ProductModel.self, from: data)
                    self.product = json
                    DispatchQueue.main.async {
                        self.configure()
                    }
                    print(json)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
    @IBAction func amountPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            amount -= 1
        } else {
            amount += 1
        }
        amoutLabel.text = String(amount)
    }
    @IBAction func addCartPressed(_ sender: UIButton) {
        let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
        let productId = product._id ?? ""
        let url = URL(string: "http://localhost:5000/api/cart/")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let params = [
            "userId": userId,
            "productId": productId,
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
                    let json = try jsonDecoder.decode(CartModel.self, from: data)
                    print(json)
                    DispatchQueue.main.async {
                        self.viewCart.isHidden = false
                        self.addCartButton.isHidden = true
                        let cart = CartViewController()
                        self.navigationController?.pushViewController(cart, animated: true)
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}

extension ProductDetailViewController {
    func configure() {
        let url = URL(string: product.img ?? "")
        detailImageView.kf.setImage(with: url)
        priceDetail.text = "\(product.price ?? 0) VND"
        nameProduct.text = product.title
        descProduct.text = product.desc
        ratingLb.text = String(format: "%.1f", product.reviewscore ?? 0)
        cosmosView.rating = product.reviewscore ?? 0
        checkButtonLike()
    }
    func checkButtonLike() {
        if likeButton.isSelected {
            likeButton.tintColor = .systemPink
        } else {
            likeButton.tintColor = .gray
        }
    }
    func checkProductToCart() {
        let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
        let productId = product._id ?? ""
        let url = URL(string: "http://localhost:5000/api/cart/check")!
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
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        let json = try jsonDecoder.decode(CartModel.self, from: data)
                        print(json)
                        DispatchQueue.main.async {
                            self.viewCart.isHidden = false
                            self.addCartButton.isHidden = true
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.viewCart.isHidden = true
                        self.addCartButton.isHidden = false
                    }
                }
        }
        task.resume()
    }
}

