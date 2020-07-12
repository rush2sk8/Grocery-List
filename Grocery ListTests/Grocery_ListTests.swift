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

    private var store: Store!
    
    override func setUpWithError() throws {
        self.store = Store(name: "Wegmans")
    }
    
    
    func testStoreName(){
        XCTAssertTrue(store.name == "Wegmans")
    }
  
  

}
