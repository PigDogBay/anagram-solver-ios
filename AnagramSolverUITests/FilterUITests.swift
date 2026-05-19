//
//  FilterUITests.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 19/05/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import XCTest

class FilterUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    ///Regression test for the ellipsis bug
    ///Ensure Pattern and RegExp text fields convert the ellipsis … back into 3 dots ...
    func testEllipsisBug1(){
        let app = XCUIApplication()
        
        //1. Enable .webSearch keyboard type, by enabling Allow Dictation
        //press settings button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        //press Reset button to ensure settings are in a known state
        app.navigationBars.buttons["Reset"].tap()
        //Accessibility ID can be applied to child elements, so need to use first match
        app.alerts.buttons["dialogResetSettings"].firstMatch.tap()
        app.switches["dictationToggle"].switches.firstMatch.tap()
        //press back button
        app.navigationBars.buttons.element(boundBy: 0).tap()

        
        //2. Delete any query text and enter ....., check no ellipsis … chars are present
        app.textFields.element.tap()
        app.mpdbDeleteAll()
        app.mpdbUIType(msg: ".....") //Ensure keyboard keys are tapped
        XCTAssertEqual(app.textFields.element.value as! String, ".....")

        //3. Tap Search and Filters buttons
        app.navigationBars.buttons["Search"].tap()
        app.navigationBars.buttons["Filters"].tap()
        
        //Clear any existing filters
        app.buttons["CLEAR"].tap()
        //Pattern filter is 7th textField (index 6)
        app.swipeUp()
        app.swipeUp()
        app.textFields["Pattern"].tap()
        app.mpdbUIType(msg: ".....")
        app.textFields["Reg Exp"].tap()
        app.mpdbUIType(msg: ".....")
        app.navigationBars.buttons["Apply"].tap()
        XCTAssertTrue(app.staticTexts["Matches: 5000 Filters: 2"].waitForExistence(timeout: SEARCH_TIMEOUT))
    }
    
}
