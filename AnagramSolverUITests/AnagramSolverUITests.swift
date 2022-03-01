//
//  AnagramSolverUITests.swift
//  AnagramSolverUITests
//
//  Created by Mark Bailey on 01/03/2022.
//  Copyright © 2022 MPD Bailey Technology. All rights reserved.
//

import XCTest

/**
 UI Test code examples
 
 Tutorial
 https://www.hackingwithswift.com/articles/83/how-to-test-your-user-interface-using-xcode
 Cheat Sheet
 https://www.hackingwithswift.com/articles/148/xcode-ui-testing-cheat-sheet
 */
class AnagramSolverUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.textFields.element.tap()
        app.mpdbUIType(msg: "test")
//        app.keys["t"].tap()
//        app.keys["e"].tap()
//        app.keys["s"].tap()
//        app.keys["t"].tap()
        app.buttons["Search"].tap()
        
        XCTAssertTrue(app.staticTexts["Matches: 12"].waitForExistence(timeout: 2.5))
    }

//SLOW - launches app 10x
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
