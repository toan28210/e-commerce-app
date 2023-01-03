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
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchDataCart()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    func setupNavigation() {
        title = "Shopping Cart"
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.backgroundColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    func formatter(total: Int) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        return formatter.string(for: total) ?? ""
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
        let home = HomeViewController()
        navigationController?.pushViewController(home, animated: true)
    }
    @IBAction func checkoutPressed(_ sender: UIButton) {
        let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
        let url = URL(string: "http://localhost:5000/api/orders")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let params: [String: Any] = [
            "userId": userId,
            "amount": total
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
                    let json = try jsonDecoder.decode(OrderModel.self, from: data)
                    for cart in self.carts {
                        self.insertOrderDetail(otherId: json._id ?? "", productId: cart.productId ?? "", quantity: cart.quantity ?? 0)
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
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
        let url = URL(string: "http://localhost:5000/api/cart/\(cartId)")!
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
                self.fetchDataCart()
            }
        }
        task.resume()
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
    func fetchDataCart() {
        let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
        let url = URL(string: "http://localhost:5000/api/cart/find/\(userId)")!
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
                    let json = try jsonDecoder.decode([CartModel].self, from: data)
                    self.carts = json
                    self.total = 0
                    DispatchQueue.main.sync {
                        self.tableView.reloadData()
                        self.checkItemCart()
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}

extension CartViewController: CartCellDelegate {
    func subTotal(qty: Int, price: Int) {
        total += qty * price
        self.subtotal.text = "\(formatter(total: total)) VND"
        self.totalLb.text = "\(formatter(total: total)) VND"
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
        let url = URL(string: "http://localhost:5000/api/orderdetails")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let params: [String: Any] = [
            "orderId": otherId,
            "productId": productId,
            "quantity": quantity
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
                    DispatchQueue.main.sync {
                        print("Da xoa het")
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}
