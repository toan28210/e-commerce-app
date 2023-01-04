//
//  FagoritesViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 03/01/2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet weak var farTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorites"
        configureTableView()
        registerCell()
    }
    private func configureTableView() {
        farTableView.delegate = self
        farTableView.dataSource = self
    }
    private func registerCell() {
        farTableView.register(CartCell.nib(), forCellReuseIdentifier: CartCell.identifier)
    }
}
extension FavoritesViewController: UITableViewDelegate {
    
}

extension FavoritesViewController: UITableViewDataSource {
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
