//
//  StartSevice.swift
//  AppDATN
//
//  Created by Toan Tran on 05/12/2022.
//

import Foundation

final class StartSevice {
    static let shared = StartSevice()
    func getStartDatas() -> [StartModels] {
        return [
            StartModels(startImage: "img-unsplash1-image", startTitle: "Get Discounts On All Products", startDes: "Larem ipsum dolor sit amet..."),
            StartModels(startImage: "img-unsplash2-image", startTitle: "Get Discounts On All Products", startDes: "Larem ipsum dolor sit amet..."),
            StartModels(startImage: "img-unsplash3-image", startTitle: "Get Discounts On All Products", startDes: "Larem ipsum dolor sit amet..."),
            StartModels(startImage: "img-unsplash4-image", startTitle: "Get Discounts On All Products", startDes: "Larem ipsum dolor sit amet...")
        ]
    }
}
