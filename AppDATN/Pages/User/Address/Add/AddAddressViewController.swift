//
//  AddAddressViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 25/12/2022.
//

import UIKit

class AddAddressViewController: UIViewController {
    @IBOutlet weak var emailTxt: CustomTextField!
    @IBOutlet weak var nameTxt: CustomTextField!
    @IBOutlet weak var phoneTxt: CustomTextField!
    @IBOutlet weak var addressTxt: CustomTextField!
    @IBOutlet weak var zipcodeTxt: CustomTextField!
    @IBOutlet weak var countryTxt: CustomTextField!
    @IBOutlet weak var cityTxt: CustomTextField!
    @IBOutlet weak var saveSwitch: UISwitch!
    
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
            guard let name = nameTxt.text else {
                return ""
            }
            return name
        }
    }
    
    var phone: String {
        get {
            guard let email = phoneTxt.text else {
                return ""
            }
            return email
        }
    }
    
    var address: String {
        get {
            guard let email = addressTxt.text else {
                return ""
            }
            return email
        }
    }
    var code: String {
        get {
            guard let email = zipcodeTxt.text else {
                return ""
            }
            return email
        }
    }
    var city: String {
        get {
            guard let email = cityTxt.text else {
                return ""
            }
            return email
        }
    }
    
    var country: String {
        get {
            guard let email = countryTxt.text else {
                return ""
            }
            return email
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Address"
    }
    @IBAction func addAddressPressed(_ sender: UIButton) {
        let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
        let url = URL(string: "http://localhost:5000/api/address")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let params: [String: Any] = [
            "userId": userId,
            "name": name,
            "email": email,
            "phone": phone,
            "address": address,
            "zipcode": code,
            "city": city,
            "country": country
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
                    print(json)
                    DispatchQueue.main.async {
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}
