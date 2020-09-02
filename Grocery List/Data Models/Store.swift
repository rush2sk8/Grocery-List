//
//  Store.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//
import UIKit

class Store: Codable {
    var name: String
    var imgName: String

    var categories: [Category]

    init(name: String, img: String, _ categories: [Category] = [Category]()) {
        self.name = name
        self.categories = categories
        imgName = img
    }

    init() {
        name = ""
        categories = [Category]()
        imgName = ""
    }

    // initializes with default categories
    init(name: String) {
        self.name = name
        categories = [Category]()
        imgName = ""
    }

    public func addItem(category: Category, item: Item) {
        category.items.append(item)
        save()
    }

    public func addItem(category: String, item: Item) {
        getCategory(name: category)?.items.append(item)
        save()
    }

    public func editItem(category: Category, itemIndex: Int, newItemName: String) {
        category.items[itemIndex].name = newItemName
        save()
    }

    public func deleteItem(category: String, item: Item) {
        let items = getCategory(name: category)!.items

        var index = -1

        for i in 0 ..< items.count {
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

    func addItemFromVoiceString(_ text: String) {
        var strings = text.components(separatedBy: " ").map { x in x.lowercased() }

        if strings.contains("add") {
            strings.remove(at: strings.firstIndex(of: "add")!)
        }

        var index = -1

        if strings.contains("category") {
            index = strings.lastIndex(of: "category")!
        } else if strings.contains("kategory") {
            index = strings.lastIndex(of: "kategory")!
        } else if strings.contains("under") {
            index = strings.lastIndex(of: "under")!
        } else {
            addItem(category: "Other", item: Item(name: strings[0 ..< strings.count].joined(separator: " ").capitalized))
            return
        }

        if index + 1 < strings.count {
            var categoryString = strings[(index + 1) ..< strings.count].joined(separator: " ").capitalized
            categoryString = categoryReplacement(categoryString)

            if index - 1 >= 0 {
                let itemName: String = strings[0 ..< index].joined(separator: " ").capitalized

                if getCategories().contains(categoryString.lowercased()) {
                    addItem(category: categoryString, item: Item(name: itemName))
                } else {
                    addItem(category: "Other", item: Item(name: itemName))
                }
            }
        }
    }

    // TODO: move this to an alias field in the category
    // this is horrible
    private func categoryReplacement(_ categoryString: String) -> String {
        if categoryString == "veggies" {
            return "vegetables"
        } else if categoryString == "fruit" {
            return "fruits"
        } else if categoryString == "meat" {
            return "meats"
        } else if categoryString == "frozen" {
            return "frozen foods"
        } else {
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

        for x in categories {
            total += x.getNonDoneItems()
        }
        return total
    }

    public func getNumItems() -> Int {
        var total = 0

        for c in categories {
            total += c.items.count
        }
        return total
    }

    func addCategory(category: Category) {
        categories.append(category)
    }

    // gets a category from name
    func getCategory(name: String) -> Category? {
        for c in categories {
            if c.name == name {
                return c
            }
        }
        return nil
    }

    // function that will export the current list to url to share
    func exportToURL() -> URL? {
        guard let encoded = try? JSONEncoder().encode(self) else { return nil }

        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        guard let path = documents?.appendingPathComponent("/\(name.lowercased()).groclst") else { return nil }

        do {
            try encoded.write(to: path, options: .atomicWrite)
            return path
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    public func getStoreImage() -> UIImage? {
        return StoreIconManager.getImageFromString(imgString: imgName)
    }

    func save() {
        DataStore.saveStoreData(store: self)
    }
}
