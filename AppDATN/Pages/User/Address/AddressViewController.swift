//
//  AddressViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 21/12/2022.
//

import UIKit

class AddressViewController: UIViewController, AddressCellDelegate {
    @IBOutlet weak var addressTableView: UITableView!
    var address: [AddressModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Address"
        navigationController?.isNavigationBarHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        configure()
        registerCell()
        fetchAddress()
    }
    
    @IBAction func updateAddressPressed(_ sender: UIButton) {

    }
    @objc func addTapped() {
        let addAddress = AddAddressViewController()
        navigationController?.pushViewController(addAddress, animated: true)
    }
    
    func configure() {
        addressTableView.delegate = self
        addressTableView.dataSource = self
    }
    func registerCell() {
        addressTableView.register(AddRCell.nib(), forCellReuseIdentifier: AddRCell.identifier)
    }

}

extension AddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension AddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddRCell.identifier, for: indexPath) as? AddRCell else {
            return AddRCell()
        }
        cell.delegate = self
        cell.configureView(address: address[indexPath.row])
        return cell
    }
    
    
}

extension AddressViewController {
    func fetchAddress() {
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
                        self.addressTableView.reloadData()
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}

extension AddressViewController: AddRCellDelegate {
    func reload() {
        addressTableView.reloadData()
    }
}
