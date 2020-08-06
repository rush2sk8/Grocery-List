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
    
    public func deleteItem(category: String, item: Item){
        let items = getCategory(name: category)!.items
        
        var index = -1
        
        for i in 0..<items.count {
            if items[i].name == item.name {
                index = i
                break
            }
        }
        
        if index != -1 {
            getCategory(name: category)?.items.remove(at: index)
        }
    
        save()
    }
    
    func addItemFromVoiceString(_ text: String){
        var strings = text.components(separatedBy: " ").map { x in x.lowercased() }
        
        if strings.contains("add"){
            strings.remove(at: strings.firstIndex(of: "add")!)
        }
        
        var index = -1
        
        if strings.contains("category")   {
            index = strings.lastIndex(of: "category")!
        }else if strings.contains("kategory") {
            index = strings.lastIndex(of: "kategory")!
        }else if strings.contains("under"){
            index = strings.lastIndex(of: "under")!
        }else {
            self.addItem(category: "Other", item: Item(name: strings[0..<strings.count].joined(separator: " ").capitalized))
            return
        }
        
        if index + 1  < strings.count {
            var categoryString = strings[(index + 1)..<strings.count].joined(separator: " ").capitalized
            categoryString = categoryReplacement(categoryString)
            
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
    }
    
    //TODO: move this to an alias field in the category
    //this is horrible
    private func categoryReplacement(_ categoryString: String) -> String {
        if categoryString == "veggies"{
            return "vegetables"
        }
        else if categoryString == "fruit" {
            return "fruits"
        }
        else if categoryString == "meat"{
            return "meats"
        }
        else if categoryString == "frozen"{
            return "frozen foods"
        }
        else {
            return categoryString
        }
    }
    
    public func finishShopping() {
        for category in categories {
            category.pruneNonFavorites()
            category.resetFavorites()
        }
        
        save()
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
//        self.categories = [
//            Category(name: "Vegetables"),
//            Category(name: "Fruits"),
//            Category(name: "Bread"),
//            Category(name: "Meats"),
//            Category(name: "Dairy"),
//            Category(name: "Cleaning Supplies"),
//            Category(name: "Snacks"),
//            Category(name: "Baking"),
//            Category(name: "Beauty"),
//            Category(name: "Frozen Foods"),
//            Category(name: "Other")
//        ]
        
        self.categories = [Category]()
        
    }
    
    func addCategory(category: Category){
        self.categories.append(category)
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
