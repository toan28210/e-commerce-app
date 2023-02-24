//
//  LoginViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 05/12/2022.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passTextField: CustomTextField!
    @IBOutlet weak var rememberBtn: UIButton!
    @IBOutlet weak var checkBoxImage: UIImageView!
    let userDefault = UserDefaults.standard
    var email: String {
        get {
            guard let email = emailTextField.text else {
                return ""
            }
            return email
        }
    }
    var pass: String {
        get {
            guard let pass = passTextField.text else {
                return ""
            }
            return pass
        }
    }
    let validation = ValidationTextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefault.setValue(true, forKey: "checkNewUser")
        setupView()
        checkboxRemember()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func changeEmail(_ sender: Any) {
        if let email = emailTextField.text {
            if validation.invalidEmail(email){
                loginBtn.isEnabled = true
            } else {
                print("Invalid Email Address")
                loginBtn.isEnabled = false
            }
        }
    }
    @IBAction func changePass(_ sender: Any) {
        if let password = passTextField.text {
            if validation.invalidPassword(password){
                loginBtn.isEnabled = true
            } else {
                print("Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character")
                loginBtn.isEnabled = false
            }
        }
    }
    
    @IBAction func rememberPass(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        let signUp = RegisterViewController()
        navigationController?.pushViewController(signUp, animated: true)
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        checkRememberClickLogin()
        let url = URL(string: "http://localhost:5000/api/auth/login")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let params = [
            "email": email,
            "password": pass
        ]
        let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.httpBody = bodyData
        let task = URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil || data == nil {
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
                let json = try jsonDecoder.decode(UserModel.self, from: data)
                self.userDefault.set(json._id, forKey: "userid")
                self.userDefault.set(json.username, forKey: "username")
                self.userDefault.set(json.email, forKey: "useremail")
                DispatchQueue.main.async {
                    let home = TabbarController.shared.tabbar()
                    self.navigationController?.pushViewController(home, animated: true)
                    //                        Application.shared.setupMainInterface()
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

extension LoginViewController {
    func setupView() {
        emailTextField.borderStyle = .none
        passTextField.borderStyle = .none
    }
    
    func checkboxRemember() {
        if let emailRemember = userDefault.string(forKey: "emailRemember"), let passRemember = userDefault.string(forKey: "passRemember") {
            emailTextField.text = emailRemember
            passTextField.text = passRemember
            rememberBtn.isSelected = !rememberBtn.isSelected
            loginBtn.isEnabled = true
        }
        
    }
    func checkRememberClickLogin() {
        if rememberBtn.isSelected {
            userDefault.set(email, forKey: "emailRemember")
            userDefault.set(pass, forKey: "passRemember")
        } else {
            userDefault.removeObject(forKey: "emailRemember")
            userDefault.removeObject(forKey: "passRemember")
        }
    }
}
