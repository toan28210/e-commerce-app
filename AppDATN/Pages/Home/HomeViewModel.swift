//
//  HomeViewModel.swift
//  AppDATN
//
//  Created by Toan Tran on 10/01/2023.
//

import Foundation

final class HomeViewModel {
    func getProducts(completion: @escaping(Result<[ProductModel], Error>) -> Void) {
        NetworkService.shared.getAllProduct { results in
            switch results {
            case .success(let products):
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
