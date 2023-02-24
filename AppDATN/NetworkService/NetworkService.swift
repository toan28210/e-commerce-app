//
//  NetworkService.swift
//  AppDATN
//
//  Created by Toan Tran on 06/01/2023.
//

import Foundation

struct NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func loginUser(email: String, password: String, completion: @escaping(Result<UserModel, Error>) -> Void) {
        let params = [
            "email": email,
            "password": password
        ]
        reques(route: .signin, method: .post, parameters: params, completion: completion)
    }
    func getUser(userId: String, completion: @escaping(Result<UserModel, Error>) -> Void) {
        reques(route: .getUser(userId), method: .get, completion: completion)
    }
    
    func getAllProduct(completion: @escaping(Result<[ProductModel], Error>) -> Void) {
        reques(route: .getAllProduct, method: .get, completion: completion)
    }
    
    func checkLike(userId: String, productId: String, completion: @escaping(Result<LikeModel,Error>) -> Void) {
        let params = [
            "userId": userId,
            "productId": productId
        ]
        reques(route: .checkLike, method: .post , parameters: params, completion: completion)
    }
    func addCart(userId: String, productId: String, completion: @escaping(Result<CartModel, Error>) -> Void) {
        let params = [
            "userId": userId,
            "productId": productId
        ]
        reques(route: .addCard, method: .post, parameters: params, completion: completion)
    }
    func checkProductToCart(userId: String, productId: String, completion: @escaping(Result<CartModel, Error>) -> Void) {
        let params = [
            "userId": userId,
            "productId": productId
        ]
        reques(route: .checkProductToCart, method: .post, parameters: params, completion: completion)
    }
    
    func like(userId: String, productId: String, completion: @escaping(Result<LikeModel, Error>) -> Void) {
        let params = [
            "userId": userId,
            "productId": productId
        ]
        reques(route: .like, method: .post, parameters: params, completion: completion)
    }
    
    func updateLikeProduct(productId: String, numberLike: Int, completion: @escaping(Result<ProductModel, Error>) -> Void) {
        let params = [
            "like": numberLike
        ]
        reques(route: .updateLikeProduct(productId), method: .patch, parameters: params, completion: completion)
    }
    
    func checkOut(userId: String, total: Int, address: String, completion: @escaping(Result<OrderModel, Error>)-> Void) {
        let params: [String: Any] = [
            "userId": userId,
            "amount": total,
            "address": address
        ]
        reques(route: .checkOut, method: .post, parameters: params, completion: completion)
    }
    
    func getDataCart(userId: String, completion: @escaping(Result<[CartModel], Error>) -> Void) {
        reques(route: .getDataCart(userId), method: .get, completion: completion)
    }
    
    func addOrderDetail(orderId: String, productId: String, quantity: Int, completion: @escaping(Result<CartModel, Error>) -> Void ) {
        let params: [String: Any] = [
            "orderId": orderId,
            "productId": productId,
            "quantity": quantity
        ]
        reques(route: .addOrderDetail, method: .post, parameters: params, completion: completion)
    }
    
    func reques<T: Decodable>(route: Route, method: Method, parameters: [String: Any]? = nil, completion: @escaping(Result<T, Error>) -> Void) {
        guard let request = createRequest(route: route, method: method, parameters: parameters) else {
            completion(.failure(AppError.unknownError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var result: Result<Data, Error>?
            if let data = data {
                result = .success(data)
                let responseString = String(data: data, encoding: .utf8) ?? "Could not stringify our data"
                print("The response is:\n\(responseString)")
            } else if let error = error {
                result = .failure(error)
                print("The error is: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.handleResponse(result: result, completion: completion)
            }
        }.resume()
    }
    func handleResponse<T: Decodable>(result: Result<Data, Error>?,
                                              completion: (Result<T, Error>) -> Void) {
        guard let result = result else {
            completion(.failure(AppError.unknownError))
            return
        }
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(T.self, from: data) else {
                completion(.failure(AppError.errorDecoding))
                return
            }
            completion(.success(response))
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func createRequest(route: Route,
                               method: Method,
                               parameters: [String: Any]? = nil) -> URLRequest? {
        let urlString = Route.baseUrl + route.description
        guard let url = urlString.asUrl else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method {
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
                urlRequest.url = urlComponent?.url
            case .post, .delete, .patch, .put:
                let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = bodyData
            }
        }
        return urlRequest
    }
}
