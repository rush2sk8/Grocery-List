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

    var name: String
    var isDone: Bool = false
    var description: String
    var isExpanded: Bool = false // if there is image to expand
    var favorite: Bool = false
    
    init(name: String, imageString: String, isDone: Bool) {
        self.name = name.lowercased()
        self.imageString = imageString
        self.isDone = isDone
        self.description = ""
    }

    init(name: String, isDone: Bool) {
        self.name = name.lowercased()
        self.isDone = isDone
        self.description = ""
    }

    init(name: String) {
        self.name = name.lowercased()
        isDone = false
        self.description = ""
    }

    init(name: String, isFav: Bool) {
        self.name = name
        isDone = false
        self.description = ""
    }

    init() {
        name = ""
        isDone = false
        self.description = ""
    }

    init(name: String, imageString: String, _ description: String = "") {
        self.name = name.lowercased()
        self.imageString = imageString
        isDone = false
        self.description = description
    }

    func isExpandable() -> Bool {
        return description != "" || hasImage() 
    }
    
    func getImage() -> UIImage? {
        if hasImage() {
            let newImageData = Data(base64Encoded: imageString!)
            if let img = newImageData {
                return UIImage(data: img)
            }
        }
        return nil
    }

    func hasImage() -> Bool {
        return imageString != nil && imageString! != ""
    }
    
    func getGreyImage() -> UIImage? {
        if hasImage() {
            let ciImage = CIImage(image: getImage()!)
            let bw = ciImage!.applyingFilter("CIColorControls", parameters: ["inputSaturation": 0, "inputContrast": 1])
            return UIImage(ciImage: bw)
        }
        return nil
    }
}
