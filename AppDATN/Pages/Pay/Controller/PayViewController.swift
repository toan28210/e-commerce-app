//
//  PayViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 10/02/2023.
//

import UIKit

class PayViewController: UIViewController, ChooseHeaerDelegate {
    
    var carts: [CartModel]
    let total: Int
    var address: [AddressModel] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var payButton: UIButton!
    private let viewModel = CartViewModel()
    var headerTableView: PayHeaderView = {
        let headerTableView = PayHeaderView()
        return headerTableView
    }()
    
    var footerTableView: PayFooterView = {
        let footerTableView = PayFooterView()
        return footerTableView
    }()

    
    init(carts: [CartModel], total: Int) {
        self.carts = carts
        self.total = total
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAddress()
        setupNav()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        getAddress()
        tableView.register(PayTableViewCell.nib(), forCellReuseIdentifier: PayTableViewCell.identifier)
        tableView.tableHeaderView = headerTableView
        tableView.tableFooterView = footerTableView
        headerTableView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        footerTableView.configure(qty: carts.count, total: total)
        totalPrice.text = "đ\(FormatNumber.shared.formatter(total: total))"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
    }
    func setupNav() {
        let yourBackImage = UIImage(named: "img-back-image")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        title = "Thanh toán"
    }

    func pushView() {
        let chosseAddressVC = ChosseAddressViewController()
        chosseAddressVC.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.pushViewController(chosseAddressVC, animated: true)
    }
    @IBAction func payPressed(_ sender: UIButton) {
        guard let userId = UserDefaults.standard.value(forKey: "userid") as? String else {return}
        viewModel.checkOut(userId: userId, total: total, address: address[0]._id ?? "", carts: carts) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let order):
                for cart in strongSelf.carts {
                    strongSelf.insertOrderDetail(otherId: order._id ?? "", productId: cart.productId ?? "", quantity: cart.quantity ?? 0)
                    strongSelf.showAleart()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func showAleart() {
        let alert = UIAlertController(title: "Mua hàng thành công", message:"", preferredStyle: .alert)
        
        //Khởi tạo các action (các nút) cho alert
        let alertActionOk = UIAlertAction(title: "OK", style: .default) { (act) in
            self.navigationController?.popViewController(animated: true)
        }
        
        //Thêm các action vào alert
        alert.addAction(alertActionOk)
        
        //Hiển thị alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension PayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PayTableViewCell.identifier, for: indexPath) as? PayTableViewCell else {
            return PayTableViewCell()
        }
        cell.configure(cart: carts[indexPath.row])
        return cell
    }
}

extension PayViewController {
    func getAddress() {
        let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
        let url = URL(string: "http://localhost:5000/api/address/find/default/\(userId)")!
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
                    self.address = json
                    DispatchQueue.main.async {
                        self.headerTableView.updateUI(address: json[0])
                        self.tableView.reloadData()
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
    
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
    func deleteAllCart() {
        guard let userId = UserDefaults.standard.value(forKey: "userid") as? String else {return}
        viewModel.deleteAllCart(userId: userId) { [weak self] isSuccess in
            guard let strongSelf = self else {return}
            if isSuccess {
                strongSelf.tableView.reloadData()
            }
        }
    }
    
}
