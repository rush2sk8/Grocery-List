//
//  Category.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//
class Category: Codable {
    var name: String
    var items: [String]
    var collapsed: Bool  
    
    init(name: String, items: [String] = [String](), collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }

     
}
