//
//  CartViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 05/12/2022.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var subtotal: UILabel!		
    @IBOutlet weak var totalLb: UILabel!
    @IBOutlet weak var showCartEmpty: UIView!
    @IBOutlet weak var showCart: UIView!
    lazy var carts: [CartModel] = []
    lazy var total = 0
    var products: [Products] = []
    private let viewModel = CartViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchDataCart()
        setupNav()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDataCart()
        setupNav()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
        
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//    }
    func setupNav() {
        let yourBackImage = UIImage(named: "img-back-image")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        self.title = "Giỏ hàng"
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func checkItemCart() {
        if carts.count == 0 {
            showCartEmpty.isHidden = false
            showCart.isHidden = true
        } else {
            showCartEmpty.isHidden = true
            showCart.isHidden = false
        }
    }
    @IBAction func startPressed(_ sender: UIButton) {
        let home = TabbarController.shared.tabbar()
        home.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(home, animated: false)
    }
    @IBAction func checkoutPressed(_ sender: UIButton) {
        let payVC = PayViewController(carts: carts, total: total)
        self.navigationController?.pushViewController(payVC, animated: true)
//        guard let userId = UserDefaults.standard.value(forKey: "userid") as? String else {return}
//        viewModel.checkOut(userId: userId, total: total, carts: carts) { [weak self] result in
//            guard let strongSelf = self else {return}
//            switch result {
//            case .success(let order):
//                for cart in strongSelf.carts {
//                    strongSelf.insertOrderDetail(otherId: order._id ?? "", productId: cart.productId ?? "", quantity: cart.quantity ?? 0)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    @objc func handleBack(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
}

extension CartViewController {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartCell.nib(), forCellReuseIdentifier: CartCell.identifier)
        
    }
    func deleteItemCart(cartId: String) {
        viewModel.deleteItem(cartId: cartId) { [weak self] isSuccess in
            guard let strongSelf = self else {return}
            if isSuccess {
                print(cartId)
                DispatchQueue.main.async {
                    strongSelf.fetchDataCart()
                }
            }
        }
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "") { acion, view, complete in
            self.deleteItemCart(cartId: self.carts[indexPath.section]._id ?? "")
        }
        action.image = UIImage(named: "img-delete-image")
        return UISwipeActionsConfiguration(actions: [action])
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
}

extension CartViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return carts.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.identifier, for: indexPath) as? CartCell else {
            return UITableViewCell()
        }
        let id = carts[indexPath.section].productId ?? ""
        let cartId = carts[indexPath.section]._id ?? ""
        cell.fetchProductCart(id: id)
        cell.cartId = cartId
        cell.qty = carts[indexPath.section].quantity ?? 0
        cell.delegate = self
        return cell
    }
}

extension CartViewController {
    func deleteAllCart() {
        guard let userId = UserDefaults.standard.value(forKey: "userid") as? String else {return}
        viewModel.deleteAllCart(userId: userId) { [weak self] isSuccess in
            guard let strongSelf = self else {return}
            if isSuccess {
                strongSelf.carts = []
                strongSelf.tableView.reloadData()
                strongSelf.checkItemCart()
            }
        }
    }
    func fetchDataCart() {
        guard let userId = UserDefaults.standard.value(forKey: "userid") as? String else {return}
        viewModel.fetchDataCart(userId: userId) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let carts):
                strongSelf.total = 0
                strongSelf.carts = carts
                strongSelf.tableView.reloadData()
                strongSelf.checkItemCart()
            case .failure(let error):
                print(error)
            }
        }
    }
    

}

extension CartViewController: CartCellDelegate {
    func subTotal(qty: Int, price: Int) {
        total += qty * price
        self.subtotal.text = "\(FormatNumber.shared.formatter(total: total)) VND"
        self.totalLb.text = "\(FormatNumber.shared.formatter(total: total)) VND"
    }
    func updateItemCart(qty: Int, cartId: String) {
        let url = URL(string: "http://localhost:5000/api/cart/\(cartId)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let params = [
            "quantity": qty
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
                    let _ = try jsonDecoder.decode(CartModel.self, from: data)
                    self.fetchDataCart()

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}

extension CartViewController {
    func insertOrderDetail(otherId: String, productId: String, quantity: Int) {
        viewModel.addOrderDetail(orderId: otherId,
                                 productId: productId,
                                 quantity: quantity) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(_):
                strongSelf.deleteAllCart()
            case .failure(let error):
                print(error)
            }
        }
    }
}
