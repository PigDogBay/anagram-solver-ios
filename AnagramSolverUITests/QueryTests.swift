//
//  ShowMeCrash.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 29/09/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import XCTest

class QueryTests: XCTestCase {
    
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
    
    ///See #Issue 23
    ///Crash occurred on iOS 18 when pressing SHOW ME and the query was replaced by a smaller string
    ///The app crashed as the text selection became out of range
    func testShowMeCrash() throws {
        let app = XCUIApplication()
        app.textFields.element.tap()
        app.mpdbDeleteAll()
        app.typeText("averylongstringindeed")
        //replace programmatically with a smaller string
        app.buttons["SHOW ME"].firstMatch.tap()
    }

    ///Ensure ... is not converted to an ellipsis
    ///This test types out x......x and then checks that this is what is displayed
    ///Note keyboard type B setting, this is the keyboard that uses smart punctuation that converts ... to an ellipsis
    func testEllipsis() throws {
        let app = XCUIApplication()

        //press settings button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        //press Reset button to ensure settings are in a known state
        app.navigationBars.buttons["Reset"].tap()
        //Accessibility ID can be applied to child elements, so need to use first match
        app.alerts.buttons["dialogResetSettings"].firstMatch.tap()

        app.swipeUp()
        //Select keyboard type B as this generates the ellipsis
        app.switches["dictationToggle"].switches.firstMatch.tap()
        //press back button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.textFields.element.tap()
        app.mpdbDeleteAll()
        app.mpdbUIType(msg: "x......x")
        sleep(2)
        let query = app.textFields.element.value as? String
        XCTAssertTrue("x......x" == query)
    }
    
}
