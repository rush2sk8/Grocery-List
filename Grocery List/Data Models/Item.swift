//
//  Item.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/29/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//
import UIKit

class Item: Codable {
    var imageString: String?

    var hasImage: Bool {
        imageString != nil
    }

    var name: String
    var isDone: Bool = false
    var isFavorite: Bool

    init(name: String, isFave: Bool, imageString: String, isDone: Bool) {
        self.name = name.lowercased()
        self.imageString = imageString
        self.isDone = isDone
        isFavorite = isFave
    }

    init(name: String, isFave: Bool, isDone: Bool) {
        self.name = name.lowercased()
        self.isDone = isDone
        isFavorite = isFave
    }

    init(name: String) {
        self.name = name.lowercased()
        isDone = false
        isFavorite = false
    }

    init(name: String, isFav: Bool) {
        self.name = name
        isDone = false
        isFavorite = isFav
    }

    init() {
        name = ""
        isDone = false
        isFavorite = false
    }

    init(name: String, imageString: String) {
        self.name = name.lowercased()
        self.imageString = imageString
        isDone = false
        isFavorite = false
    }

    func getImage() -> UIImage? {
        if hasImage {
            let newImageData = Data(base64Encoded: imageString!)
            if let img = newImageData {
                return UIImage(data: img)
            }
        }
        return nil
    }

    func getGreyImage() -> UIImage? {
        if hasImage {
            let ciImage = CIImage(image: getImage()!)
            let bw = ciImage!.applyingFilter("CIColorControls", parameters: ["inputSaturation": 0, "inputContrast": 1])
            return UIImage(ciImage: bw)
        }
        return nil
    }
}
