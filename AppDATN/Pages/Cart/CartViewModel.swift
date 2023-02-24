//
//  CartViewModel.swift
//  AppDATN
//
//  Created by Toan Tran on 10/01/2023.
//

import Foundation

final class CartViewModel {
    func deleteItem(cartId: String, completion: @escaping(Bool) -> Void) {
        let url = URL(string: "http://localhost:5000/api/cart/find/\(cartId)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil || data == nil {
                    print("Client error!")
                    completion(false)
                    return
                }
                guard let response = res as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error!")
                    completion(false)
                    return
                }
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    completion(false)
                    return
                }
            if let _ = data {
                completion(true)
            }
        }
        task.resume()
    }
    
    func checkOut(userId: String, total: Int, address: String, carts: [CartModel], completion: @escaping(Result<OrderModel, Error>) -> Void) {
        NetworkService.shared.checkOut(userId: userId, total: total, address: address) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchDataCart(userId: String, completion: @escaping(Result<[CartModel], Error>) -> Void) {
        NetworkService.shared.getDataCart(userId: userId) { result in
            switch result {
            case .success(let carts):
                completion(.success(carts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addOrderDetail(orderId: String,
                        productId: String,
                        quantity: Int,
                        completion: @escaping(Result<CartModel, Error>) -> Void) {
        NetworkService.shared.addOrderDetail(orderId: orderId,
                                             productId: productId,
                                             quantity: quantity) { result in
            switch result {
            case .success(let cart):
                completion(.success(cart))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteAllCart(userId: String, completion: @escaping(Bool) -> Void) {
        let url = URL(string: "http://localhost:5000/api/cart/\(userId)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil || data == nil {
                    print("Client error!")
                    completion(false)
                    return
                }
            guard let response = res as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(false)
                print("Server error!")
                return
            }
            guard let mime = response.mimeType, mime == "application/json" else {
                completion(false)
                print("Wrong MIME type!")
                return
            }
            guard let _ = data else {
                completion(false)
                return
            }
            DispatchQueue.main.async {
                completion(true)
            }
        }
        task.resume()
    }
}
