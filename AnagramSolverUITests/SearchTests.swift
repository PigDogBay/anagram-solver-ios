//
//  SearchTests.swift
//  AnagramSolverUITests
//
//  Created by Mark Bailey on 04/03/2022.
//  Copyright © 2022 MPD Bailey Technology. All rights reserved.
//

import XCTest

class SearchTests: XCTestCase {

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
    
    /// Close Shave is in the phrase list and can be also found via two word anagram search
    /// Test that close shave only appears once
    func testNoDupliucates1() throws {
        let app = XCUIApplication()
        app.textFields.element.tap()
        app.typeText("cloes-shaev")
        app.buttons["Search"].tap()
        XCTAssertTrue(app.staticTexts["Matches: 446"].waitForExistence(timeout: SEARCH_TIMEOUT))
        XCTAssertTrue(app.tables.element.staticTexts["close shave"].exists)

        //No check it is not duplicated lower down the list
        //Unfortunately, close shave is scrolled past on iPod and IPhone 13 sim
        for _ in 1...5 {
            app.swipeUp()
            //Use hittable to check for visible elements
            XCTAssertFalse(app.tables.element.staticTexts["close shave"].isHittable)
        }

        //Set up a prefix filter to reduce number of matches
        app.buttons["Filters"].tap()
        //Prefix filter is 5th textField (index 4)
        app.textFields.element(boundBy: 4).tap()
        app.mpdbUIType(msg: "close")
        app.buttons["Search"].tap()
        XCTAssertTrue(app.staticTexts["Matches: 3 Filters: 1"].waitForExistence(timeout: SEARCH_TIMEOUT))
    }
    
    func testCrosswordVowel1(){
        let app = XCUIApplication()
        app.textFields.element.tap()
        app.typeText("gr!!.")
        app.buttons["Search"].tap()
        XCTAssertTrue(app.staticTexts["Matches: 27"].waitForExistence(timeout: SEARCH_TIMEOUT))

    }

    func testCrosswordVowel2(){
        let app = XCUIApplication()
        app.textFields.element.tap()
        app.typeText("t!!ter@")
        app.buttons["Search"].tap()
        XCTAssertTrue(app.staticTexts["Matches: 9"].waitForExistence(timeout: SEARCH_TIMEOUT))
        XCTAssertTrue(app.tables.element.staticTexts["teeterboards"].waitForExistence(timeout: SEARCH_TIMEOUT))
    }

    func testCrosswordVowel3(){
        let app = XCUIApplication()
        app.textFields.element.tap()
        app.typeText("moonstarer")
        app.buttons["Search"].tap()
        XCTAssertTrue(app.tables.element.staticTexts["astronomer"].waitForExistence(timeout: SEARCH_TIMEOUT))

        //Set up filter
        app.buttons["Filters"].tap()
        //Prefix filter is 7th textField (index 6)
        app.textFields.element(boundBy: 6).tap()
        app.typeText(".!!.!!.")
        app.buttons["Search"].tap()
        XCTAssertTrue(app.staticTexts["Matches: 2 Filters: 1"].waitForExistence(timeout: SEARCH_TIMEOUT))
        XCTAssertTrue(app.tables.element.staticTexts["searoom (ntr)"].waitForExistence(timeout: SEARCH_TIMEOUT))
        XCTAssertTrue(app.tables.element.staticTexts["tearoom (nsr)"].waitForExistence(timeout: SEARCH_TIMEOUT))
    }
}
