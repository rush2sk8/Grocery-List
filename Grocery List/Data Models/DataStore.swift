//
//  DataManager.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/6/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

class DataStore {
    static func saveStoreData(store: Store) {
        let encode = try! JSONEncoder().encode(store)
        let string = String(bytes: encode, encoding: .utf8)!

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("\(store.name.lowercased()).json")

            do {
                try string.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func mergeToExistingListAndSave(store: Store) {
        let existing = DataStore.getStoreData(store: store)

        for category in existing!.categories {
            let items = store.getCategory(name: category.name)!.items

            for item in items {
                if category.getItems().contains(item.name) == false {
                    existing!.getCategory(name: category.name)?.items.append(item)
                }
            }
        }

        DataStore.saveStoreData(store: existing!)
    }

    static func importList(from url: URL) {
        let data = try? Data(contentsOf: url)
        let store = try? JSONDecoder().decode(Store.self, from: data!)

        if let names = DataStore.getStoreNames() {
            if names.contains(store!.name) {
                DataStore.mergeToExistingListAndSave(store: store!)
            } else {
                DataStore.saveNewStore(store: store!.name)
                DataStore.saveStoreData(store: store!)
            }
        } else {
            DataStore.saveNewStore(store: store!.name)
            DataStore.saveStoreData(store: store!)
        }

        try? FileManager.default.removeItem(at: url)
    }

    static func deleteStore(store: Store) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = dir.appendingPathComponent("\(store.name.lowercased()).json")

            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func getStoreData(store: Store) -> Store? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("\(store.name.lowercased()).json")

            do {
                let jsonData = try String(contentsOf: fileURL, encoding: .utf8).data(using: .utf8)!

                if let store = try? JSONDecoder().decode(Store.self, from: jsonData) {
                    return store
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    static func getStoreNames() -> [String]? {
        let defaults = UserDefaults.standard
        if let stores = defaults.stringArray(forKey: "stores") {
            return stores.map { x in x.lowercased() }
        }
        return nil
    }

    static func saveStores(stores: [Store]) {
        let defaults = UserDefaults.standard

        var storeNames = [String]()

        for store in stores {
            storeNames.append(store.name.lowercased())
        }

        if let _ = defaults.stringArray(forKey: "stores") {
            defaults.removeObject(forKey: "stores")
            defaults.synchronize()

            defaults.set(storeNames, forKey: "stores")
            defaults.synchronize()
        } else {
            defaults.set(storeNames, forKey: "stores")
            defaults.synchronize()
        }
    }

    static func saveNewStore(store: String) {
        let defaults = UserDefaults.standard

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("\(store.lowercased()).json")

            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)

            let storeToSave = Store(name: store.lowercased())
            DataStore.saveStoreData(store: storeToSave)
        }

        if var stores = defaults.stringArray(forKey: "stores") {
            stores.append(store)

            defaults.set(stores, forKey: "stores")
            defaults.synchronize()
        } else {
            defaults.set([store], forKey: "stores")
            defaults.synchronize()
        }
    }
}
