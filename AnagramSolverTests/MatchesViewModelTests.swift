//
//  MatchesViewModelTests.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 14/04/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//


import SwiftUtils
import Testing

@MainActor
@Suite("MatchesViewModel tests", .serialized)
struct MatchesViewModelTests {
    @Test func search1() async throws {
        let model = Model()
        let filters = Filters()
        let viewModel = MatchesViewModel(query: "", model: model, filters: filters)
        try await model.engine.loadWordList(name:"words")
        viewModel.search(word: "ab initoi")
        //Wait for search Task to complete
        try await Task.sleep(for: .seconds(1))
        #expect(model.appState == .finished)
        #expect(viewModel.grouped[0][0] == "ab initio")
        #expect(viewModel.grouped[0][1] == "ai biotin")
    }

}
