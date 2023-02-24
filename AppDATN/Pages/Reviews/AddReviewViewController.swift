//
//  AddReviewViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 24/12/2022.
//

import UIKit
import Cosmos

class AddReviewViewController: UIViewController {

    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var responTextView: UITextView!
    var productId = ""
    var rating = 0
    var reviewScore = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        title = "Viết đánh về sản phẩm"
        tabBarController?.tabBar.isHidden = true
        cosmosView.settings.fillMode = .full
    }
    
    @IBAction func test(_ sender: UIButton) {
        let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
        let url = URL(string: "http://localhost:5000/api/rating")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let res = responTextView.text ?? ""
        let params: [String: Any] = [
            "userId": userId,
            "productId": productId,
            "rating": cosmosView.rating,
            "response": res
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
                    let json = try jsonDecoder.decode(RatingModel.self, from: data)
                    self.reviewScore += json.rating ?? 0
                    self.updateRatingProduct()
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}

extension AddReviewViewController {
    func updateRatingProduct() {
        let url = URL(string: "http://localhost:5000/api/products/\(productId)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        let count = rating + 1
        if count != 1 {
            reviewScore = reviewScore / Double(2)
        }
        let params: [String: Any] = [
            "rating": count,
            "reviewscore": reviewScore
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
                    let json = try jsonDecoder.decode(ProductModel.self, from: data)
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                    print(json)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}
