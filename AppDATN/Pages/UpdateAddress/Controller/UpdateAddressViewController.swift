//
//  UpdateAddressViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 19/02/2023.
//

import UIKit
import CoreLocation
import MapKit

class UpdateAddressViewController: UIViewController {
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var locationView: LocationView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    let mapViewController: MapViewController = {
        let mapViewController = MapViewController()
        return mapViewController
    }()
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
    
    var addressStreet: String {
        get {
            guard let email = streetTextField.text else {
                return ""
            }
            return email
        }
    }
    var quan: String? = nil
    var huyen: String? = nil
    var city: String? = nil
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()

        locationView.isHidden = true
        if let city = city, let huyen = huyen, let quan = quan {
            cityLabel.textColor = .black
            cityLabel.text = "\(city) \n\(huyen) \n\(quan)"
        } else {
            cityLabel.textColor = .lightGray
            cityLabel.text = "Tỉnh/Thành phố, Quận/Huyện, Phường/Xã"
        }
    }
    
    func setupNav() {
        let yourBackImage = UIImage(named: "img-back-image")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        title = "Địa chỉ mới"
    }
    
    func center1(location: CLLocation) {
        locationView.mapView.setCenter(location.coordinate, animated: true)
        //zoom
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        self.locationView.mapView.setRegion(region, animated: true)
        self.addAnnotation1(location: location)
        }
    func addAnnotation1(location: CLLocation) {
            let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            annotation.title = ""
            annotation.subtitle = ""
        LocationManager.shared().getAddressFromLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { address, error in
            self.locationView.isHidden = false
            if error != nil {
                print(error ?? "")
            } else if let address = address {
                print(address)
            }
        }
        locationView.mapView.addAnnotation(annotation)
        }

    @IBAction func mapPressed(_ sender: UIButton) {
        let vc = MapViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func streetPressed(_ sender: UITextField) {
        LocationManager.shared().getLocation(from: "\(addressStreet), \(quan ?? ""), \(huyen ?? ""), \(city ?? "")") { location in
            if let location = location {
                let latitude = location.latitude
                let longitude = location.longitude
                let locationn: CLLocation = .init(latitude: latitude, longitude: longitude)
                self.center1(location: locationn)
            }
        }
    }
    
    @IBAction func addAddress(_ sender: UIButton) {
        addAddressPressed()
    }
    private func addAddressPressed() {
        let address = "\(quan ?? ""), \(huyen ?? ""), \(city ?? "")"
        let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
        let url = URL(string: "http://localhost:5000/api/address")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let params: [String: Any] = [
            "userId": userId,
            "name": name,
            "phone": phone,
            "addressStreet": addressStreet,
            "address": address,
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
