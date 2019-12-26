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
}
