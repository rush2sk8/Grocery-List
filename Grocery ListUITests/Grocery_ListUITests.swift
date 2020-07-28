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
    
    func testItemFavorite() {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Wegmans"]/*[[".cells.staticTexts[\"Wegmans\"]",".staticTexts[\"Wegmans\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let toolbar = app.toolbars["Toolbar"]
        toolbar.children(matching: .other).element.children(matching: .other).element.children(matching: .button).matching(identifier: "Item").element(boundBy: 1).tap()
        
        let itemNameTextField = app.textFields["Item Name"]
        itemNameTextField.tap()
        app.textFields.firstMatch.typeText("Milk")
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Dairy"]/*[[".cells.staticTexts[\"Dairy\"]",".staticTexts[\"Dairy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        toolbar.buttons["Add Item"]/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 1.5);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        
        let milkStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Milk"]/*[[".cells.staticTexts[\"Milk\"]",".staticTexts[\"Milk\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssertTrue(milkStaticText.exists)
        
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["star.fill"]/*[[".cells.buttons[\"star.fill\"]",".buttons[\"star.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        milkStaticText.swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertTrue(milkStaticText.exists)
    }
    
    func testItemUnfavoriteDelete(){
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Wegmans"]/*[[".cells.staticTexts[\"Wegmans\"]",".staticTexts[\"Wegmans\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["star.fill"]/*[[".cells.buttons[\"star.fill\"]",".buttons[\"star.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Milk"]/*[[".cells.staticTexts[\"Milk\"]",".staticTexts[\"Milk\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        XCUIApplication().tables/*@START_MENU_TOKEN@*/.buttons["Delete"].tap()/*[[".cells.buttons[\"Delete\"]",".tap()",".press(forDuration: 0.5);",".buttons[\"Delete\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,1]]@END_MENU_TOKEN@*/
        
        XCTAssertFalse(tablesQuery.staticTexts["Milk"].exists)
    }
    
    func testFinishShopping() {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery.cells.containing(.staticText, identifier:"Wegmans").element.tap()
        
        let toolbar = app.toolbars["Toolbar"]
        let itemButton = toolbar.children(matching: .other).element.children(matching: .other).element.children(matching: .button).matching(identifier: "Item").element(boundBy: 1)
        itemButton.tap()
        
        let itemNameTextField = app.textFields["Item Name"]
        itemNameTextField.tap()
        app.textFields.firstMatch.typeText("Milk")
        
        let dairyStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Dairy"]/*[[".cells.staticTexts[\"Dairy\"]",".staticTexts[\"Dairy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        dairyStaticText.tap()
        
        let addItemButton = toolbar.buttons["Add Item"]
        addItemButton.tap()
        
        toolbar.buttons["Done"].tap()
        
        let elementsQuery = app.alerts["Are you sure you're finished?"].scrollViews.otherElements
        
        XCTAssertTrue(elementsQuery.staticTexts["Your list still has 1 items left"].exists)
        elementsQuery.buttons["Yes"]/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 0.9);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        
        XCTAssertFalse(tablesQuery.staticTexts["Milk"].exists)
        XCTAssertFalse(tablesQuery.staticTexts["Cheese"].exists)
        
        addTeardownBlock {
            let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
            
            XCUIApplication().terminate()
            let icon = springboard.icons["Grocery List"]
            
            if icon.exists {
                let icFrame = icon.frame
                let springFrame = springboard.frame
                icon.press(forDuration: 5)
                
                springboard.coordinate(withNormalizedOffset: CGVector(dx: (icFrame.minX + 3) / springboard.frame.maxX, dy: (icFrame.minY + 3) / springFrame.maxY)).tap()
                springboard.alerts.buttons["Delete"].tap()
            }
        }
    }

}

extension XCUIElement {
    
    func clearText(andReplaceWith newText: String? = nil){
        tap()
        press(forDuration: 1.0)
        var select = XCUIApplication().menuItems["Select All"]
        
        if !select.exists {
            select = XCUIApplication().menuItems["Select"]
        }
        
        if select.waitForExistence(timeout: 0.5) , select.exists {
            select.tap()
            
           XCUIApplication().menuItems["Cut"].tap()
        } else{
            tap()
        }
        
        if let newVal = newText {
            typeText(newVal)
        }
    }
}
