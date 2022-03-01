//
//  AnagramSolverUITestsLaunchTests.swift
//  AnagramSolverUITests
//
//  Created by Mark Bailey on 01/03/2022.
//  Copyright © 2022 MPD Bailey Technology. All rights reserved.
//

import XCTest

/*
 Opens the app in for every config (orientation, darkmode)
 Takes a screenshot which can be viewed in the test report
 (Right click on the test and click view report)
 */
class AnagramSolverUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
/*
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
 */
}
