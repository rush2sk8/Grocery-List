//
//  Store.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation

class Store: Codable {
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
            Category(name: "Beauty"),
            Category(name: "Frozen Foods"),
            Category(name: "Other")
        ]
    }
    
    // gets a category from name
    func getCategory(name: String) -> Category? {
        for c in self.categories {
            if c.name == name {
                return c
            }
        }
        return nil
    }
    
    //function that will export the current list to url to share
    func exportToURL() -> URL? {
        guard let encoded = try? JSONEncoder().encode(self) else { return nil }
        
        let documents = FileManager.default.urls (for: .documentDirectory, in: .userDomainMask).first
        
        guard let path = documents?.appendingPathComponent("/\(self.name.lowercased()).groclst") else { return nil }
        
        do {
            try encoded.write(to: path, options: .atomicWrite)
            return path
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
