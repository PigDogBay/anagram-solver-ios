//
//  SymbolBarTests.swift
//  AnagramSolverUITests
//
//  Created by Mark Bailey on 30/09/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import XCTest

final class SymbolBarTests: XCTestCase {

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

    func testExample() throws {
        let app = XCUIApplication()

        //press settings button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        //press Reset button to ensure settings are in a known state
        app.navigationBars.buttons["Reset"].tap()
        //Accessibility ID can be applied to child elements, so need to use first match
        app.alerts.buttons["dialogResetSettings"].firstMatch.tap()

        app.swipeUp()
        //Select keyboard type B as this generates the ellipsis
        app.switches["showKeyboardToggle"].switches.firstMatch.tap()
        app.switches["symbolBarToggle"].switches.firstMatch.tap()
        app.switches["dictationToggle"].switches.firstMatch.tap()
        //press back button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.textFields.element.tap()
        app.mpdbDeleteAll()
        app.mpdbUIType(msg: "x")
        app.buttons["!"].tap()
        app.buttons["?"].tap()
        app.buttons["!"].tap()
        app.mpdbUIType(msg: "x")
        sleep(2)
        let query = app.textFields.element.value as? String
        XCTAssertTrue("x!?!x" == query)
    }
}
