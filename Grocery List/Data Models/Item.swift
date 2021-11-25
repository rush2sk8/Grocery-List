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
<<<<<<< HEAD

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
=======
    
    var hasImage: Bool {
        imageString != nil
    }
    
    var name: String
    var isDone: Bool = false
    var isFavorite: Bool
    
    init(name: String, isFave: Bool, imageString: String, isDone: Bool){
        self.name = name
        self.imageString = imageString
        self.isDone = isDone
        self.isFavorite = isFave
    }
    
    init(name: String, isFave: Bool, isDone: Bool){
        self.name = name
        self.isDone = isDone
        self.isFavorite = isFave
>>>>>>> 3c3471d0c7e0b4df8d7eac34ec4f0848b513723c
    }
    
    init(name: String) {
<<<<<<< HEAD
        self.name = name.lowercased()
        isDone = false
        self.description = ""
=======
        self.name = name
        self.isDone = false
        self.isFavorite = false
>>>>>>> 3c3471d0c7e0b4df8d7eac34ec4f0848b513723c
    }
    
    init(name: String, isFav: Bool) {
        self.name = name
<<<<<<< HEAD
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
=======
        self.isDone = false
        self.isFavorite = isFav
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
>>>>>>> 3c3471d0c7e0b4df8d7eac34ec4f0848b513723c
            let newImageData = Data(base64Encoded: imageString!)
            if let img = newImageData {
                return UIImage(data: img)
            }
        }
        return nil
    }
<<<<<<< HEAD

    func hasImage() -> Bool {
        return imageString != nil && imageString! != ""
    }
    
    func getGreyImage() -> UIImage? {
        if hasImage() {
=======
    
    func getGreyImage() -> UIImage? {
        if hasImage{
>>>>>>> 3c3471d0c7e0b4df8d7eac34ec4f0848b513723c
            let ciImage = CIImage(image: getImage()!)
            let bw = ciImage!.applyingFilter("CIColorControls", parameters: ["inputSaturation": 0, "inputContrast": 1])
            return UIImage(ciImage: bw)
        }
        return nil
    }
}
