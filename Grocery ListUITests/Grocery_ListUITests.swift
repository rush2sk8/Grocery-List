//
//  Grocery_ListUITests.swift
//  Grocery ListUITests
//
//  Created by Rushad Antia on 7/19/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import XCTest

class Grocery_ListUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testAddStore(){
        
        //launch app
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Stores"]/*[[".buttons[\"Stores\"].staticTexts[\"Stores\"]",".staticTexts[\"Stores\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        //add store
        app.navigationBars["Stores"].buttons["Add"].tap()
        
        //type "wegmans"
        app.textFields.firstMatch.typeText("Wegmans")
        XCTAssertTrue((app.textFields.firstMatch.value as! String) == "Wegmans")
        
        //add the store
        app.alerts["Store Name"].scrollViews.otherElements.buttons["Add"].tap()
        
        //click on the store
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Wegmans"]/*[[".cells.staticTexts[\"Wegmans\"]",".staticTexts[\"Wegmans\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertTrue(app.navigationBars["Wegmans"].staticTexts["Wegmans"].exists)
    }
}
