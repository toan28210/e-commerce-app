//
//  ProductDetailViewModel.swift
//  AppDATN
//
//  Created by Toan Tran on 10/01/2023.
//

import Foundation

final class ProductDetailViewModel {
    func checkLike(userId: String, productId: String, completion: @escaping(Result<LikeModel, Error>) -> Void) {
        NetworkService.shared.checkLike(userId: userId, productId: productId) { result in
            switch result {
            case .success(let like):
                completion(.success(like))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addCart(userId: String, productId: String, completion: @escaping(Bool) -> Void) {
        NetworkService.shared.addCart(userId: userId, productId: productId) { result in
            switch result {
            case .success(_):
               completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func checkProductToCart(userId: String, productId: String, completion: @escaping(Bool) -> Void) {
        NetworkService.shared.checkProductToCart(userId: userId, productId: productId) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func like(userId: String, productId: String, completion: @escaping(Result<LikeModel, Error>) -> Void) {
        NetworkService.shared.like(userId: userId, productId: productId) { result in
            switch result {
            case .success(let like):
                completion(.success(like))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func unLike(likeId: String, completion: @escaping(Bool) -> Void) {
        let url = URL(string: "http://localhost:5000/api/like/\(likeId)")!
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
    
    func updateLikeProduct(productId: String, numberLike: Int, completion: @escaping(Result<ProductModel, Error>) -> Void) {
        NetworkService.shared.updateLikeProduct(productId: productId, numberLike: numberLike) { result in
            switch result {
            case .success( let product):
                completion(.success(product))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
