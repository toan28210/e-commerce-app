//
//  CategoriesModel.swift
//  AppDATN
//
//  Created by Toan Tran on 20/12/2022.
//

import Foundation

struct CategoriesModel: Decodable {
    let id: String
    let name: String
    let image: String
}

class CategoriesSevice {
    static let shared = CategoriesSevice()
    func getData() -> [CategoriesModel] {
        return [
            CategoriesModel(id: "1", name: "Phone", image: "anh"),
            CategoriesModel(id: "1", name: "Phone", image: "anh"),
            CategoriesModel(id: "1", name: "Phone", image: "anh"),
            CategoriesModel(id: "1", name: "Phone", image: "anh"),
            CategoriesModel(id: "1", name: "Phone", image: "anh"),
            CategoriesModel(id: "1", name: "Phone", image: "anh"),
            CategoriesModel(id: "1", name: "Phone", image: "anh"),
            CategoriesModel(id: "1", name: "Phone", image: "anh"),
            CategoriesModel(id: "1", name: "Phone", image: "anh"),
            CategoriesModel(id: "1", name: "Phone", image: "anh"),
            CategoriesModel(id: "1", name: "Phone", image: "anh"),
            CategoriesModel(id: "1", name: "Phone", image: "anh"),
            CategoriesModel(id: "1", name: "Phone", image: "anh")
        ]
    }
}
