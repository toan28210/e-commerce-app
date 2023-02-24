//
//  ChosseAddressViewController.swift
//  AppDATN
//
//

import UIKit

class ChosseAddressViewController: UIViewController, FooterViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var address: [AddressModel] = []
    
//    var headerTableView: ChosseHeaderView = {
//        let headerTableView = ChosseHeaderView()
//        return headerTableView
//    }()

    var footerTableView: FooterView = {
        let footerTableView = FooterView()
        return footerTableView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if let headerView = tableView.tableHeaderView {
//            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//            var headerFrame = headerView.frame
//            if height != headerFrame.size.height {
//                headerFrame.size.height = height
//                headerView.frame = headerFrame
//                tableView.tableHeaderView = headerView
//            }
//        }
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
        getAddress()
        setupNav()
        title = "Chọn địa chỉ nhận hàng"
        tableView.register(ChosseAddressTableViewCell.nib(), forCellReuseIdentifier: ChosseAddressTableViewCell.identifier)
//        tableView.tableHeaderView = headerTableView
        tableView.tableFooterView = footerTableView
        footerTableView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNav() {
        let yourBackImage = UIImage(named: "img-back-image")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    func addAddress() {
        let addAddress = UpdateAddressViewController()
        self.navigationController?.pushViewController(addAddress, animated: true)
    }
}

extension ChosseAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChosseAddressTableViewCell.identifier, for: indexPath) as? ChosseAddressTableViewCell else {
            return ChosseAddressTableViewCell()
        }
        cell.configUI(item: address[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addressId = address[indexPath.row]._id ?? ""
        updateAddress(addressId: addressId)
    }
}

extension ChosseAddressViewController {
    func getAddress() {
        let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
        let url = URL(string: "http://localhost:5000/api/address/find/\(userId)")!
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
                        self.tableView.reloadData()
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
    
    private func updateAddress(addressId: String) {
        let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
        let url = URL(string: "http://localhost:5000/api/address/user/\(userId)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        let params: [String: Any] = [
            "isdefault": false
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
                    guard let _ = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.updateAddressDefault(addressId: addressId)
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
    
    private func updateAddressDefault(addressId: String) {
        let url = URL(string: "http://localhost:5000/api/address/\(addressId)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        let params: [String: Any] = [
            "isdefault": true,
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
                    let json = try jsonDecoder.decode(AddressModel.self, from: data)
                    DispatchQueue.main.async {
                        self.getAddress()
                        self.tableView.reloadData()
                        self.navigationController?.popViewController(animated: true)
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}

