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
    /// Helper to create a basic view model setup
    private func makeViewModel(query: String = "test") -> (MatchesViewModel, Filters) {
        let filters = Filters()
        let model = Model()
        let viewModel = MatchesViewModel(query: query, model: model, filters: filters)
        return (viewModel, filters)
    }

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


        @Test("Share output contains basic query information")
        func shareBasicFormat() {
            let (viewModel, _) = makeViewModel(query: "lemon")
            viewModel.matches = ["melon", "lemon"]
            
            let result = viewModel.share()
            
            #expect(result.count == 1)
            let content = result[0]
            
            #expect(content.contains("-Anagram Solver-"))
            #expect(content.contains("Query:\nlemon"))
            #expect(content.contains("Matches:\nmelon\nlemon\n"))
        }

        @Test("Share output includes active filters when present")
        func shareWithFilters() {
            let (viewModel, filters) = makeViewModel(query: "star")
            filters.contains = "s"
            filters.prefix = "st"
            filters.isActive = true
            viewModel.matches = ["star"]
            
            let result = viewModel.share()
            let content = result[0]
            
            #expect(content.contains("Filters:"))
            #expect(content.contains("Contains letters s"))
            #expect(content.contains("Starting with st"))
        }

        @Test("Share output omits filter section when no filters are active")
        func shareWithoutFilters() {
            let (viewModel, _) = makeViewModel(query: "star")
            viewModel.matches = ["star"]
            
            let result = viewModel.share()
            let content = result[0]
            
            #expect(!content.contains("Filters:"))
        }

        @Test("Share output includes App Store link")
        func shareIncludesStoreLink() {
            let (viewModel, _) = makeViewModel()
            
            let result = viewModel.share()
            let content = result[0]
            
            #expect(content.contains("Available on the App Store"))
            #expect(content.contains("https://itunes.apple.com/app/"))
        }
    
    

}
