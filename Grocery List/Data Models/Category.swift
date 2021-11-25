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
    var toAdd: Bool

    init(name: String, items: [Item] = [Item](), collapsed: Bool = false) {
        self.name = name
        self.name = name.lowercased()
        self.items = items
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

    func removeNonFavorites() {
        self.items = items.filter { $0.favorite }
        for item in self.items {
            item.isDone = false
        }
    }
}
