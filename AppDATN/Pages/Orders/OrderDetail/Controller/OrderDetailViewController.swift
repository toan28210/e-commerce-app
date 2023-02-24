//
//  OrderDetailViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 09/02/2023.
//

import UIKit

class OrderDetailViewController: UIViewController {
    let order: OrderModel
    
    @IBOutlet weak var tableView: UITableView!
    
    var headerTableView: OrderDetailHeaderView = {
        let headerTableView = OrderDetailHeaderView()
        return headerTableView
    }()
    
    var footerTableView: OrderDetailFooterView = {
        let footerTableView = OrderDetailFooterView()
        return footerTableView
    }()

    
    init(order: OrderModel) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
        
        if let footerView = tableView.tableFooterView {
            let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = footerView.frame
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                footerView.frame = headerFrame
                tableView.tableFooterView = footerView
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAddress()
        title = "Chi tiết đơn hàng"
        tableView.register(OrderDetailTableViewCell.nib(), forCellReuseIdentifier: OrderDetailTableViewCell.identifier)
        tableView.tableHeaderView = headerTableView
        tableView.tableFooterView = footerTableView
        footerTableView.config(order: order)
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.details?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailTableViewCell.identifier, for: indexPath) as? OrderDetailTableViewCell else {
            return OrderDetailTableViewCell()
        }
        
        if let orderDetail = order.details?[indexPath.row] {
            cell.configUI(orderDetail: orderDetail)
        }
        return cell
    }
    
    func getAddress() {
        let addressId = order.address ?? ""
        let url = URL(string: "http://localhost:5000/api/address/find/add/\(addressId)")!
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
                    let json = try jsonDecoder.decode([AddressModel].self, from: data)
//                    self.headerTableView.nameLabel.text = json[0].name ?? ""
//                    self.headerTableView.phoneNumber.text = "(+84) \(json[0].phone ?? 0)"
//                    self.headerTableView.addressLabel.text = "\(json[0].addressStreet ?? ""), \(json[0].address ?? "")"
                    DispatchQueue.main.async {
                        self.headerTableView.updateUI(address: json[0])
                        self.tableView.reloadData()
                    }

                } catch {
                    print("JSON error orderdetail: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
    
    
}
