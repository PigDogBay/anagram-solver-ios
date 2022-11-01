//
//  SettingsTests.swift
//  AnagramSolverUITests
//
//  Created by Mark Bailey on 04/03/2022.
//  Copyright © 2022 MPD Bailey Technology. All rights reserved.
//

import XCTest

class SettingsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

        let app = XCUIApplication()
        //press settings button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        //press Reset button to ensure settings are in a known state
        app.buttons["Reset"].tap()
        app.buttons["dialogResetSettings"].tap()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let app = XCUIApplication()
        //press settings button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        //press Reset button to ensure settings are in a known state
        app.buttons["Reset"].tap()
        app.buttons["dialogResetSettings"].tap()
    }

    
    /// Tests the Letter Case setting
    /// Run on the iPod, as requires keyboard
    func testLetterCase1() throws {
        let app = XCUIApplication()
        app.descendants(matching: .switch).matching(identifier: "caseToggle").element.tap()
        //press back button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        //Do a search
        app.textFields.element.tap()
        app.mpdbUIType(msg: "MOONSTARER")
        app.buttons["Search"].tap()
        XCTAssertTrue(app.tables.element.staticTexts["ASTRONOMER"].waitForExistence(timeout: SEARCH_TIMEOUT))
    }
    
    func testConvertSpaceToQuestionMark1(){
        let app = XCUIApplication()

        app.descendants(matching: .switch).matching(identifier: "convertSpaceToggle").element.tap()
        //press back button
        app.navigationBars.buttons.element(boundBy: 0).tap()

        app.textFields.element.tap()
        app.keys["o"].tap()
        app.keys["k"].tap()
        app.keys["space"].tap()
        XCTAssertEqual(app.textFields.element.value as! String, "ok?")
    }

    func testConvertFullStopToQuestionMark1(){
        let app = XCUIApplication()
        app.swipeUp()
        app.descendants(matching: .switch).matching(identifier: "convertFullStopToggle").element.tap()
        //press back button
        app.navigationBars.buttons.element(boundBy: 0).tap()

        app.textFields.element.tap()
        app.keys["o"].tap()
        app.keys["k"].tap()
        app.keys["."].tap()
        XCTAssertEqual(app.textFields.element.value as! String, "ok?")
    }
}
