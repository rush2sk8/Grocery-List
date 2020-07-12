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
    private var numItems: Int
    
    //this is support for default categories
    init(name: String, _ categories: [Category] = [Category]()) {
        self.name = name
        self.categories = categories
        self.numItems = 0
    }
    
    init() {
        self.name = ""
        self.categories = [Category]()
        self.numItems = 0
    }
    
    public func addItem(category: Category, item: Item){
        category.items.append(item)
        save()
    }
    
    public func addItem(category: String, item: Item){
        getCategory(name: category)?.items.append(item)
        save()
    }
    
    public func editItem(category: Category, itemIndex: Int, newItemName: String){
        category.items[itemIndex].name = newItemName
        save()
    }
    
    public func getNumNonDoneItems() -> Int {
        var total = 0
        
        for x in self.categories {
            total += x.getNonDoneItems()
        }
        return total
    }
    
    public func getNumItems() -> Int {
       var total = 0
        
        for c in self.categories {
            total += c.items.count
        }
        return total
    }
    
    // initializes with default categories
    init(name: String){
        self.name = name
        self.categories = [
            Category(name: "Veggies"),
            Category(name: "Fruits"),
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
        self.numItems = 0
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
    
    func save() {
        DataStore.saveStoreData(store: self)
    }
}
