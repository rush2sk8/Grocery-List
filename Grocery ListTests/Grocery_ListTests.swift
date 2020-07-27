//
//  Grocery_ListTests.swift
//  Grocery ListTests
//
//  Created by Rushad Antia on 7/12/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import XCTest

@testable import Grocery_List

class Grocery_ListTests: XCTestCase {
    //POGGERS 
    private var store: Store!
    
    override func setUpWithError() throws {
        self.store = Store(name: "Wegmans")
    }
    
    func testStoreName(){
        XCTAssertTrue(store.name == "Wegmans")
    }
  
    func testAddItemToStore(){
        store.addItem(category: "Dairy", item: Item(name: "Milk"))
        
        XCTAssertTrue(store.getCategory(name: "Dairy")?.items.first?.name == "Milk")
    }
  
    func testGetCategoryFail(){
        XCTAssertNil(store.getCategory(name: "dairy"))
    }
    
    func testGetCategoryPass(){
        XCTAssertTrue(store.getCategory(name: "Dairy")!.name == "Dairy")
    }    

    func testVoiceAddDefault(){
        self.store.addItemFromVoiceString("add coffee")
        
        XCTAssertTrue(store.getNumItems() == 1)
        XCTAssertTrue(store.getCategory(name: "Other")?.items.first?.name == "Coffee")
    }
    
    func testVoiceAddSpecific(){
        self.store.addItemFromVoiceString("add milk category dairy")
        
        XCTAssertTrue(store.getNumItems() == 1)
        XCTAssertTrue(store.getCategory(name: "Dairy")?.items.first?.name == "Milk")
    }
    
    func testVoiceAddDefaultMultipleWords(){
        self.store.addItemFromVoiceString("add honey nut cheerios")
        
        XCTAssertTrue(store.getNumItems() == 1)
        XCTAssertTrue(store.getCategory(name: "Other")?.items.first?.name == "Honey Nut Cheerios")
    }
    
    func testVoiceAddSpecificMultipleWords(){
        self.store.addItemFromVoiceString("add wipes category cleaning supplies")
        
        XCTAssertTrue(store.getNumItems() == 1)
        XCTAssertTrue(store.getCategory(name: "Cleaning Supplies")?.items.first?.name == "Wipes")
    }
    
    func testGetCategories() {
        let categories = ["vegetables", "fruits", "bread", "meats", "dairy", "cleaning supplies", "snacks", "baking", "beauty", "frozen foods", "other"]
        XCTAssertTrue(categories == self.store.getCategories())
    }
    
    func testVoiceAddSpecificMultipleWordsMisspelled(){
        self.store.addItemFromVoiceString("add wipes kategory cleaning supplies")
        
        XCTAssertTrue(store.getNumItems() == 1)
        XCTAssertTrue(store.getCategory(name: "Cleaning Supplies")?.items.first?.name == "Wipes")
    }
    
    func testVoiceAddSpecificMultipleWordsUnder(){
        self.store.addItemFromVoiceString("add wipes under cleaning supplies")
        
        XCTAssertTrue(store.getNumItems() == 1)
        XCTAssertTrue(store.getCategory(name: "Cleaning Supplies")?.items.first?.name == "Wipes")
    }
    
    func testFinishShopping(){
        store.addItem(category: "Dairy", item: Item(name: "Milk"))
        XCTAssertTrue(store.getCategory(name: "Dairy")?.items.first?.name == "Milk")
        
        store.addItem(category: "Dairy", item: Item(name: "Cheese", isFav: true))
        XCTAssertTrue(store.getCategory(name: "Dairy")?.items[1].name == "Cheese")
        
        store.finishShopping()
        XCTAssertTrue(store.getCategory(name: "Dairy")?.items.first?.name == "Cheese")
    }
    
    func testDeleteItem(){
        store.addItem(category: "Dairy", item: Item(name: "Milk"))
        XCTAssertTrue(store.getCategory(name: "Dairy")?.items.first?.name == "Milk")
        
        store.addItem(category: "Dairy", item: Item(name: "Cheese", isFav: true))
        XCTAssertTrue(store.getCategory(name: "Dairy")?.items[1].name == "Cheese")
        
        store.deleteItem(category: "Dairy", item: Item(name: "Cheese", isFav: true))
        XCTAssertTrue(store.getNumItems() == 1)
    }
    
}
