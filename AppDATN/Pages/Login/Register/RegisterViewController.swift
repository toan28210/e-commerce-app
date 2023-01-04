//
//  RegisterViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 05/12/2022.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passTextField: CustomTextField!
    @IBOutlet weak var presentLogin: UILabel!
    let userDefault = UserDefaults.standard
    var username: String {
        get {
            guard let email = usernameTextField.text else {
                return ""
            }
            return email
        }
    }
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
        setupPresentLogin()
    }
    func setupPresentLogin() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(nextPage))
        presentLogin.isUserInteractionEnabled = true
        presentLogin.addGestureRecognizer(tap)
        passTextField.borderStyle = .none
        emailTextField.borderStyle = .none
        usernameTextField.borderStyle = .none
    }
    @objc func nextPage() {
        let login = LoginViewController()	
        navigationController?.pushViewController(login, animated: true)
    }
    @IBAction func changeEmail(_ sender: Any) {
        if let email = emailTextField.text {
            if validation.invalidEmail(email){
                registerBtn.isEnabled = true
            } else {
                print("Invalid Email Address")
                registerBtn.isEnabled = false
            }
        }
    }
    @IBAction func changePass(_ sender: Any) {
        if let password = passTextField.text {
            if validation.invalidPassword(password){
                registerBtn.isEnabled = true
            } else {
                print("Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character")
                registerBtn.isEnabled = false
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        let url = URL(string: "http://localhost:5000/api/auth/register")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let params = [
            "username": username,
            "password": pass,
            "email": email
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
                    let json = try jsonDecoder.decode(UserModel.self, from: data)
                    self.userDefault.set(json._id, forKey: "userid")
                    self.userDefault.set(json.username, forKey: "userename")
                    self.userDefault.set(json.email, forKey: "useremail")
                    DispatchQueue.main.async {
                        let home = HomeViewController()
                        self.navigationController?.pushViewController(home, animated: true)
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}
// MARK: - SetupView
extension RegisterViewController {
}
