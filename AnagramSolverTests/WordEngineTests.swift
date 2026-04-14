//
//  WordEngineTests.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 14/04/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//


import Testing
import SwiftUtils

@Suite("Word Engine Search Tests")
struct WordEngineTests {
    ///Test that multi-word searches do not return duplicates
    ///There use to bug where a match was found in the Phrase and Word searches
    @Test("Verify multi-word searches remove duplicates")
    func removeDuplicates1() async throws {
        let engine = WordEngine()
        try await engine.loadWordList(name: "words")
        let query = SearchParser().parse(query: "ab initio")
        engine.combinedSearch(query, callback: engine)

        #expect(engine.working.count >= 2, "Engine should return at least two results")
        #expect(engine.working[0] == "ab initio")
        #expect(engine.working[1] == "ai biotin")
        
        // Ensure no duplicates exist in the collection
        let uniqueResults = Set(engine.working)
        #expect(uniqueResults.count == engine.working.count, "Search results should not contain duplicates")
    }
}
