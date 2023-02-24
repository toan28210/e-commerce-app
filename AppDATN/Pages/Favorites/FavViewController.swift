//
//  FavViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 08/02/2023.
//

import UIKit

class FavViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fav"
        configureTableView()
        registerCell()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func registerCell() {
        tableView.register(CartCell.nib(), forCellReuseIdentifier: CartCell.identifier)
    }


}

extension FavViewController: UITableViewDelegate {
    
}

extension FavViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.identifier, for: indexPath) as? CartCell else {
            return CartCell()
        }
        return cell
    }
}
