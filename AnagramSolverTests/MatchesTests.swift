//
//  MatchesTests.swift
//  AnagramSolverTests
//
//  Created by Mark Bailey on 15/11/2023.
//  Copyright © 2023 MPD Bailey Technology. All rights reserved.
//

import XCTest
@testable import AnagramSolver

final class MatchesTests: XCTestCase {

    func testGroup1(){
        let matches = Matches()
        matches.matchFound(match: "spectrum")
        matches.matchFound(match: "oric")
        matches.groupBySize()
        XCTAssertEqual(matches.sections, 2)
        XCTAssertEqual(matches.getNumberOfLetters(section: 0), 8)
        XCTAssertEqual(matches.getNumberOfLetters(section: 1), 4)
    }

    func testGroup2(){
        let matches = Matches()
        matches.matchFound(match: "spectrum next")
        matches.groupBySize()
        XCTAssertEqual(matches.sections, 1)
        XCTAssertEqual(matches.getNumberOfLetters(section: 0), 12)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

}
