//
//  MyOrderViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 25/12/2022.
//

import UIKit

class MyOrderViewController: UIViewController {
    @IBOutlet weak var orderTableView: UITableView!
    let box = "img-box-image"
    lazy var orders: [OrderModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Order"
        navigationController?.isNavigationBarHidden = false
        fetchOrder()
        configure()
        registerCell()
    }
    func configure() {
        orderTableView.delegate = self
        orderTableView.dataSource = self
    }
    func registerCell() {
        orderTableView.register(OrderCell.nib(), forCellReuseIdentifier: OrderCell.identifier)
    }
}

extension MyOrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension MyOrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier, for: indexPath) as? OrderCell else {
            return OrderCell()
        }
        cell.delegate = self
        return cell
    }
}

extension MyOrderViewController: OrderCellDelegate {
    func reload() {
        orderTableView.reloadData()
    }
}

extension MyOrderViewController {
    func fetchOrder() {
        let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
        let url = URL(string: "http://localhost:5000/api/orders/find/\(userId)")!
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
                    let json = try jsonDecoder.decode([OrderModel].self, from: data)
                    self.orders = json
                    var i = 0
                    for order in self.orders {
                        self.fetchOrderDetail(orderId: order._id ?? "", index: i)
                        i += 1
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
    func fetchOrderDetail(orderId: String, index: Int) {
        let url = URL(string: "http://localhost:5000/api/orderdetails/find/\(orderId)")!
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
                    let json = try jsonDecoder.decode([OrderDetailModel].self, from: data)
                    self.orders[index].details = json
                    DispatchQueue.main.async {
                        self.orderTableView.reloadData()
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}


