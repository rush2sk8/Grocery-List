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
    
    var isDone: Bool
    var isFavorite: Bool
    
    init(name: String) {
        self.name = name
        self.isDone = false
        self.isFavorite = false
    }
    
    init(){
        self.name = ""
        self.isDone = false
        self.isFavorite = false
    }
    
    init(name: String, imageString: String) {
        self.name = name
        self.imageString = imageString
        self.isDone = false
        self.isFavorite = false
    }
    
    func getImage() -> UIImage? {
        if self.hasImage{
            let newImageData = Data(base64Encoded: imageString!)
            if let img = newImageData {
                return UIImage(data: img)
            }
        }
        return nil
    }
    
    func getGreyImage() -> UIImage? {
        if hasImage{
            let ciImage = CIImage(image: getImage()!)
            let bw = ciImage!.applyingFilter("CIColorControls", parameters: ["inputSaturation": 0, "inputContrast": 1])
            return UIImage(ciImage: bw)
        }
        return nil
    }
}
