//
//  UITestUtils.swift
//  AnagramSolverUITests
//
//  Created by Mark Bailey on 01/03/2022.
//  Copyright © 2022 MPD Bailey Technology. All rights reserved.
//

import XCTest
import SwiftUI

let SEARCH_TIMEOUT : TimeInterval = 15.0

extension XCUIApplication {
    /**
     Amazing this is not already included
     Taps out a string of characters on the soft keyboard.
     */
    func mpdbUIType(msg : String) {
        msg.forEach {
            self.keys[String($0)].tap()
        }
    }
    
    func mpdbDeleteAll(){
        let stringValue = self.textFields.element.value as? String ?? ""
        for _ in 0..<stringValue.count {
            self.keyboards.keys["delete"].tap()
        }
    }
}

