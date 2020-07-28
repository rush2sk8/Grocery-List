//
//  Category.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//
class Category: Codable {
    var name: String
    var items: [Item]
    var collapsed: Bool  
    
    init(name: String, items: [Item] = [Item](), collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
    
    func getItems() -> [String] {
        var sItems: [String] = []
        for item in items {
            sItems.append(item.name)
        }
        return sItems
    }

    func getNonDoneItems() -> Int {
        var total = 0
        for item in items {
            if item.isDone == false {
                
            total += 1
            }
        }
        return total
    }
    
    func pruneNonFavorites(){
        var faves = [Item]()
        
        for item in items {
            if item.isFavorite{
                faves.append(item)
            }
        }
        self.items = faves
    }
    
    func resetFavorites(){
        for item in self.items {
            if item.isFavorite && item.isDone {
                item.isDone = false
            }
        }
    }
}
