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
    
    func testClientDeletedWithEditButton() {
        //given
        let addClientButton = app.navigationBars["Master"].buttons["Add"]
        let textField = app.alerts["Add New Client"].scrollViews.otherElements.collectionViews/*@START_MENU_TOKEN@*/.textFields["Enter Client Name"]/*[[".cells.textFields[\"Enter Client Name\"]",".textFields[\"Enter Client Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let addButton = app.alerts["Add New Client"].scrollViews.otherElements.buttons["Add"]
        let navBar = app.navigationBars["Master"]
        
        //when
        addClientButton.tap()
        textField.typeText("New Client")
        addButton.tap()
        navBar.buttons["Edit"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.buttons["Delete New Client"].tap()
        tablesQuery.buttons["trailing0"].tap()
        navBar.buttons["Done"].tap()
        
    }
}
