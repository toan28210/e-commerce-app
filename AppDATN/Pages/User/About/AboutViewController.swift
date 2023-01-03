//
//  AboutViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 24/12/2022.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var userName: CustomTextField!
    @IBOutlet weak var phoneNumberTxt: CustomTextField!
    @IBOutlet weak var emailTxt: CustomTextField!
    @IBOutlet weak var currentPass: CustomTextField!
    @IBOutlet weak var newPassTxt: CustomTextField!
    var email: String {
        get {
            guard let email = emailTxt.text else {
                return ""
            }
            return email
        }
    }
    var name: String {
        get {
            guard let name = userName.text else {
                return ""
            }
            return name
        }
    }
    var phone: String {
        get {
            guard let phone = phoneNumberTxt.text else {
                return ""
            }
            return phone
        }
    }
    let userDefault = UserDefaults.standard
    var user: UserModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        title = "About Me"
        fetchFindUser()
    }
    func fetchFindUser() {
        let userid = userDefault.value(forKey: "userid") ?? ""
        let url = URL(string: "http://localhost:5000/api/users/find/\(userid)")!
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
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonDecoder = JSONDecoder()
                    let json = try jsonDecoder.decode(UserModel.self, from: data)
                    self.user = json
                    DispatchQueue.main.async {
                        self.emailTxt.text = json.email ?? ""
                        let phoneNumber = json.phone ?? 0
                        if phoneNumber == 0 {
                            self.phoneNumberTxt.text = ""
                        } else {
                            self.phoneNumberTxt.text = "\(phoneNumber)"
                        }
                        self.userName.text = json.username ?? ""
                    }
                    print(json)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
    @IBAction func savePressed(_ sender: UIButton) {
        let userid = userDefault.value(forKey: "userid") ?? ""
        let url = URL(string: "http://localhost:5000/api/users/\(userid)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let params: [String: Any] = [
            "email": email,
            "username": name,
            "phone": phone
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
                    self.userDefault.set(json.username, forKey: "username")
                    self.userDefault.set(json.email, forKey: "useremail")
                    DispatchQueue.main.async {
                        self.emailTxt.text = json.email ?? ""
                        let phoneNumber = json.phone ?? 0
                        if phoneNumber == 0 {
                            self.phoneNumberTxt.text = ""
                        } else {
                            self.phoneNumberTxt.text = "\(phoneNumber)"
                        }
                        self.userName.text = json.username ?? ""
                        let user = UserViewController()
                        self.navigationController?.pushViewController(user, animated: true)
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}
