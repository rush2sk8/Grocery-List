//
//  Store.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation

struct Store: Codable{
    var name: String
    var categories: [Category]
    
    //this is support for default categories
    init(name: String, _ categories: [Category] = [Category]()) {
        self.name = name
        self.categories = categories
    }
    
    init() {
        self.name = ""
        self.categories = [Category]()
    }
    
    // initializes with default categories
    init(name: String){
        self.name = name
        self.categories = [
            Category(name: "Produce"),
            Category(name: "Bread"),
            Category(name: "Meats"),
            Category(name: "Dairy"),
            Category(name: "Cleaning Supplies"),
            Category(name: "Snacks"),
            Category(name: "Baking"),
            Category(name: "Frozen Foods"),
            Category(name: "Other")
        ]
    }
}
