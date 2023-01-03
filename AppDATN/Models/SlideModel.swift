//
//  SlideModel.swift
//  AppDATN
//
//  Created by Toan Tran on 20/12/2022.
//

import Foundation

struct SlideModel {
    let image: String
    let id: String
}

final class SlideModels {
    static let shared = SlideModels()
    func getDataSlide() -> [SlideModel] {
        return [
            SlideModel(image: "onepiece", id: ""),
            SlideModel(image: "anh", id: ""),
            SlideModel(image: "avatar2", id: ""),
            SlideModel(image: "dem-hung-tan", id: ""),
            SlideModel(image: "onepiece", id: ""),
            SlideModel(image: "anh", id: "")
        ]
    }
}
