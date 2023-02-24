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
    private let viewModel = ProductDetailViewModel()
    private let userId = UserDefaults.standard.value(forKey: "userid")
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chi tiết sản phẩm"
        setupNavigation()
        setupTabbar()
        descTextView()
        configure()
        customLikeButton()
        checkProductToCart()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigation()
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
        reviewLb.text = "(\(product.rating ?? 0) đánh giá)"
//        let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 11.0)
//        let readmoreFontColor = UIColor.blue
//        DispatchQueue.main.async {
//            self.descProduct.addTrailing(with: "... ", moreText: "Readmore", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
//        }
    }
    func configure() {
        let url = URL(string: product.img ?? "")
        detailImageView.kf.setImage(with: url)
        priceDetail.text = "\(product.formattedPrice) VND"
        nameProduct.text = product.title
        descProduct.text = product.desc
        ratingLb.text = String(format: "%.1f", product.reviewscore ?? 0)
        cosmosView.rating = product.reviewscore ?? 0
        checkButtonLike()
    }
    func checkButtonLike() {
        likeButton.tintColor = likeButton.isSelected ? .systemPink : .gray
    }
    func checkProductToCart() {
        guard let userId = UserDefaults.standard.value(forKey: "userid") as? String else {return}
        let productId = product._id ?? ""
        viewModel.checkProductToCart(userId: userId, productId: productId) { [weak self] isCheck in
            guard let strongSelf = self else {return}
            strongSelf.viewCart.isHidden = !isCheck
            strongSelf.addCartButton.isHidden = isCheck
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
        guard let userId = UserDefaults.standard.value(forKey: "userid") as? String else {return}
        guard let productId = product._id else {return}
        viewModel.checkLike(userId: userId, productId: productId) { [weak self] isCheck in
            guard let strongSelf = self else {return}
            switch isCheck {
            case .success(let like):
                DispatchQueue.main.async {
                    strongSelf.likeId = like._id ?? ""
                    strongSelf.likeButton.isSelected = true
                    strongSelf.checkButtonLike()
                }
            case .failure(let error):
                print(error)
            }

        }
    }
    @IBAction func likePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            guard let userId = UserDefaults.standard.value(forKey: "userid") as? String else {return}
            let productId = product._id ?? ""
            viewModel.like(userId: userId, productId: productId) { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .success(let like):
                    strongSelf.likeId = like._id ?? ""
                    //Update number like product
                    strongSelf.updateLikeProduct(like: 1 + (strongSelf.product.like ?? 0))
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            viewModel.unLike(likeId: likeId) { [weak self] isSuccess in
                guard let strongSelf = self else {return}
                if isSuccess {
                    DispatchQueue.main.async {
                        strongSelf.updateLikeProduct(like: (strongSelf.product.like ?? 0) - 1)
                    }
                }
            }
        }
    }
    func updateLikeProduct(like: Int) {
        let productId = product._id ?? ""
        viewModel.updateLikeProduct(productId: productId, numberLike: like) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let product):
                strongSelf.product = product
                strongSelf.configure()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    @IBAction func addCartPressed(_ sender: UIButton) {
        guard let userId = UserDefaults.standard.value(forKey: "userid") as? String else {return}
        guard let productId = product._id else {return}
        viewModel.addCart(userId: userId, productId: productId) { [weak self] isSuccess in
            guard let strongSelf = self else {return}
            if isSuccess {
                strongSelf.viewCart.isHidden = false
                strongSelf.addCartButton.isHidden = true
                let cart = CartViewController()
                strongSelf.navigationController?.pushViewController(cart, animated: true)
            }
        }
    }
}


