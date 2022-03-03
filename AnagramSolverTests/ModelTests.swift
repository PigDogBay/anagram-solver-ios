//
//  ModelTests.swift
//  AnagramSolverTests
//
//  Created by Mark Bailey on 03/03/2022.
//  Copyright © 2022 MPD Bailey Technology. All rights reserved.
//

import XCTest
@testable import AnagramSolver

class ModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /**
         Bug: Two word anagram searches can find multiple results, one from phrase list and one from the words list.
     */
    func testDistinctResults1() throws {
        let model = Model()
        model.applySettings()
        model.wordListName = "words"
        model.loadDictionary()
        model.query = "ab initoi"
        model.prepareToSearch()
        model.search()
        model.matches.groupBySize()
        XCTAssertEqual("ab initio", model.matches.getMatch(section: 0, row: 0))
        XCTAssertEqual("ai biotin", model.matches.getMatch(section: 0, row: 1))
    }

    func testPerformanceSearch() throws {
        let model = Model()
        model.applySettings()
        model.wordListName = "words"
        model.loadDictionary()
        model.query = "....."
        model.prepareToSearch()
        self.measure {
            model.search()
        }
    }

}

