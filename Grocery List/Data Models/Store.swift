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
    
    init(name: String, categories: [Category]) {
        self.name = name
        self.categories = categories
    }
}
