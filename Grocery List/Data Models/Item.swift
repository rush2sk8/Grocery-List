//
//  Item.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/29/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

class Item: Codable {
    var imageString: String?
    
    var hasImage: Bool {
        imageString != nil
    }
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    init(){
        self.name = ""
    }
    
    init(name: String, imageString: String) {
        self.name = name
        self.imageString = imageString
    }
    
}
