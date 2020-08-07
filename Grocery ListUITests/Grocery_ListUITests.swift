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
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["Stores"].buttons["Add"].tap()
        app.textFields["Store Name"].tap()
        app.textFields["Store Name"].typeText("Wegmans")
        app.buttons["Continue"].tap()
        app.buttons["Add Store"].tap()
 
    }
    
    func testDuplicateStore(){
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["Stores"].buttons["Add"].tap()
        
        let storeNameTextField = app.textFields["Store Name"]
        storeNameTextField.tap()
        app.textFields["Store Name"].typeText("Wegmans")
        app.buttons["Continue"].tap()
        
        XCTAssertTrue(app.staticTexts["Store Already Exists!"].exists)
    }
    
    func testEmptyStore() {
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["Stores"].buttons["Add"].tap()
        app.textFields["Store Name"].tap()
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.staticTexts["You must enter some text to continue."].exists)
    }
    
    func testStoreMultipleCustomCategoriesSuccess(){
        let app = XCUIApplication()
        app.launch()
        
    }
    
    func testStoreCustomCategoriesWithFail(){
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["Stores"].buttons["Add"].tap()
        
        app.textFields["Store Name"].tap()
        app.textFields["Store Name"].typeText("Giant")
        
        app.buttons["Continue"].tap()
        
        app.buttons["Frozen Foods"].tap()
        app.buttons["Beauty"].tap()
        app.buttons["Baking"].tap()
        app.buttons["Snacks"].tap()
        app.buttons["Cleaning Supplies"].tap()
        app.buttons["Dairy"].tap()
        app.buttons["Meats"].tap()
        app.buttons["Bread"].tap()
        app.buttons["Fruits"].tap()
        app.buttons["Vegetables"].tap()
        app.buttons["Add Store"].tap()
        
        XCTAssertTrue(app.staticTexts["Please select atleast 1 category!"].exists)
        
        app.buttons["Add Custom Categories"].tap()
        
        let finishAddingStoreButton = app.buttons["Finish Adding Store"]
        app.textFields["Category Name"].tap()
        finishAddingStoreButton.tap()
        
        XCTAssertTrue(app.staticTexts["You must enter some text to continue."].exists)
    
        app.textFields["Category Name"].tap()
                
        let cname = app.textFields["Category Name"]
        if cname.exists {
            cname.tap()
            //cname.typeText("Drinks")
            UIPasteboard.general.string = "Drinks"
            cname.press(forDuration: 1.1)
            app.menuItems["Paste"].tap()
        }
        
        app.buttons["Finish Adding Store"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Giant"]/*[[".cells.staticTexts[\"Giant\"]",".staticTexts[\"Giant\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
  
        XCTAssertTrue(app.tables["Empty list"].otherElements["Drinks"].staticTexts["Drinks"].exists)
    }
    
    func testStoreCustomCategoriesFailCustomDuplicate() {
        let app = XCUIApplication()
        app.launch()
    
        app.navigationBars["Stores"].buttons["Add"].tap()
        app.textFields["Store Name"].tap()
        app.textFields["Store Name"].typeText("Walmart")
        
        app.buttons["Continue"].tap()
        app.buttons["Frozen Foods"].tap()
        app.buttons["Beauty"].tap()
        app.buttons["Baking"].tap()
        app.buttons["Snacks"].tap()
        app.buttons["Cleaning Supplies"].tap()
        app.buttons["Dairy"].tap()
        app.buttons["Add Custom Categories"].tap()
        app.textFields["Category Name"].tap()
       
        UIPasteboard.general.string = "fruits"
        app.textFields["Category Name"].press(forDuration: 1.1)
        app.menuItems["Paste"].tap()
        
        //app.textFields["Category Name"].typeText("fruits")

        app.buttons["Finish Adding Store"].tap()
        
        let categoryAlreadyAddedStaticText = app.staticTexts["Category already added!"]
        
        XCTAssertTrue(categoryAlreadyAddedStaticText.exists)
        app.buttons["Add another custom category"].tap()
        XCTAssertTrue(categoryAlreadyAddedStaticText.exists)
    }
    
    func testTrailingWhitespaceFailure(){
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["Stores"].buttons["Add"].tap()
        
        let storeNameTextField = app.textFields["Store Name"]
        storeNameTextField.tap()
        storeNameTextField.tap()
        
        
        
        UIPasteboard.general.string = "wegmans   "
        app.textFields["Store Name"].press(forDuration: 1.1)
        app.menuItems["Paste"].tap()
        //app.textFields["Store Name"].typeText("Wegmans    ")
        
        app.buttons["Continue"].tap()
        
        XCTAssertTrue(app.staticTexts["Store Already Exists!"].exists)
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
        
        tablesQuery/*@START_MENU_TOKEN@*/.cells.buttons["star.fill"]/*[[".cells.buttons[\"star.fill\"]",".buttons[\"star.fill\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        
        milkStaticText.swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.cells.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        
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
        
        app.staticTexts["Your list still has 1 items left"].tap()
        
        XCTAssertTrue(app.staticTexts["Your list still has 1 items left"].exists)
        
        app.buttons["Yes"].tap()
        
        XCTAssertFalse(tablesQuery.staticTexts["Milk"].exists)
    
    }

    func deleteApp(){
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
