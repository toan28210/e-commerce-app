//
//  WelcomeViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 05/12/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var googleButtonView: UIControl!
    @IBOutlet weak var createButtonView: UIControl!
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    @IBAction func loginWithGoogle(_ sender: Any) {
        print("123")
    }
    @IBAction func createAccount(_ sender: UIButton) {
        let createAccount = RegisterViewController()
        createAccount.modalPresentationStyle = .fullScreen
        self.present(createAccount, animated: true)
    }
}
// MARK: - Setup View
extension WelcomeViewController {
    private func setupNavigation() {
        title = "Welcome"
        navigationController?.navigationBar.tintColor = .black
    }
    private func setupView() {
    }
}
