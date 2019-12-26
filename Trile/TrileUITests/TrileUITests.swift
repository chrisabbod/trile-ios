//
//  TrileUITests.swift
//  TrileUITests
//
//  Created by Chris Abbod on 12/26/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import XCTest

class TrileUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        
    }
    
    func testAddClientAlertDialogCancelButtonCancelsDialog() {
        //given
        let addClientButton = app.navigationBars["Master"].buttons["Add"]
        let alertDialog = app.alerts["Add New Client"]
        let cancelButton = app.alerts["Add New Client"].scrollViews.otherElements.buttons["Cancel"]

        //when
        addClientButton.tap()
        cancelButton.tap()
        
        //then
        XCTAssertTrue(!alertDialog.exists)
    }
    
    func testAddClientAlertDialogAddButtonAddsClientToList() {
        
        //given
        let addClientButton = app.navigationBars["Master"].buttons["Add"]
        let textField = app.alerts["Add New Client"].scrollViews.otherElements.collectionViews/*@START_MENU_TOKEN@*/.textFields["Enter Client Name"]/*[[".cells.textFields[\"Enter Client Name\"]",".textFields[\"Enter Client Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let addButton = app.alerts["Add New Client"].scrollViews.otherElements.buttons["Add"]
        
        //then
        addClientButton.tap()
        XCTAssertTrue(textField.exists, "Text field doesn't exist")
        textField.typeText("New Client")
        XCTAssertEqual(textField.value as! String, "New Client", "Text field value is not correct")
        addButton.tap()
    }
    
    func testClientDeletedOnSwipe() {
        //given
        let addClientButton = app.navigationBars["Master"].buttons["Add"]
        let textField = app.alerts["Add New Client"].scrollViews.otherElements.collectionViews/*@START_MENU_TOKEN@*/.textFields["Enter Client Name"]/*[[".cells.textFields[\"Enter Client Name\"]",".textFields[\"Enter Client Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let addButton = app.alerts["Add New Client"].scrollViews.otherElements.buttons["Add"]
        
        //when
        addClientButton.tap()
        textField.typeText("New Client")
        addButton.tap()
        
        //then
        let tablesQuery = app.tables
        tablesQuery.staticTexts["New Client"].swipeLeft()
        tablesQuery.buttons["Delete"].tap()
    }
}
