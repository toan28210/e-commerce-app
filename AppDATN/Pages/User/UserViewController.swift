//
//  UserViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 21/12/2022.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var pickImageButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var emailLB: UILabel!
    var userDatas = UserTableViewService.shared.getDatas()
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.cornerRadius = userImageView.frame.width/2
        pickImageButton.layer.cornerRadius = pickImageButton.frame.width/2
        configureTableView()
        updateView()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    func updateView() {
        let email = "\(userDefault.value(forKey: "useremail") ?? "")"
        let name = "\(userDefault.value(forKey: "username") ?? "")"
        nameLB.text = name
        emailLB.text = email
    }
    func configureTableView() {
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.register(UserCell.nib(), forCellReuseIdentifier: UserCell.identifier)
    }
    
    func signOut() {
        UserDefaults.standard.set("", forKey: "userid")
        self.userDefault.set("", forKey: "username")
        self.userDefault.set("", forKey: "useremail")
        let login = LoginViewController()
        navigationController?.pushViewController(login, animated: true)
    }
}
extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let addressVC = AddressViewController()
            navigationController?.pushViewController(addressVC, animated: true)
        } else if indexPath.row == 0 {
            let about = AboutViewController()
            navigationController?.pushViewController(about, animated: true)
        } else if indexPath.row == 1 {
            let order = MyOrderViewController()
            navigationController?.pushViewController(order, animated: true)
        } else if indexPath.row == 7 {
            signOut()
        } else if indexPath.row == 2 {
            let far = FavoritesViewController()
            navigationController?.pushViewController(far, animated: true)
        }
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDatas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        cell.configure(with: userDatas[indexPath.row])
        return cell
    }
}
