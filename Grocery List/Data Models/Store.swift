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
    
    func addItemFromVoiceString(_ text: String){
        var strings = text.components(separatedBy: " ").map { x in x.lowercased() }
        
        if strings.contains("add"){
            strings.remove(at: strings.firstIndex(of: "add")!)
        }
        
        if strings.contains("category") || strings.contains("kategory") {
            let index = strings.lastIndex(of: "category")!
            
            if index + 1  < strings.count {
                let categoryString = strings[(index + 1)..<strings.count].joined(separator: " ").capitalized
                
                if index - 1 >= 0 {
                    let itemName: String = strings[0..<index].joined(separator: " ").capitalized
                    
                    if self.getCategories().contains(categoryString.lowercased()){
                        self.addItem(category: categoryString, item: Item(name: itemName))
                    } else {
                        self.addItem(category: "Other", item: Item(name: itemName))
                    }
                    
                    print(categoryString)
                }
            }
        }else {
            self.addItem(category: "Other", item: Item(name: strings[0..<strings.count].joined(separator: " ").capitalized))
        }
    }
    
    public func getCategories() -> [String] {
        var categories = [String]()
        
        for c in self.categories {
            categories.append(c.name.lowercased())
        }
        return categories
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
