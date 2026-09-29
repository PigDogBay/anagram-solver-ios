//
//  SearchBarViewModelTests.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 29/09/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import Testing
import SwiftUI
@testable import AnagramSolver

@Suite("SearchBarViewModel Insert Symbol Tests")
struct SearchBarViewModelInsertTests {
    
    private func create(_ query: String, _ selection: TextSelection?) -> SearchBarViewModel {
        let viewModel = SearchBarViewModel()
        viewModel.query = query
        viewModel.selection = selection
        return viewModel
    }
   
    
    @Test("Inserting symbol with no selection appends to end")
    func insertSelectionNil() {
        let initialQuery = "moonstarer"
        let initialSelection : TextSelection? = nil
        let expectedQuery = "moonstarer?"
        let expectedSelection = TextSelection(insertionPoint: expectedQuery.endIndex)

        let viewModel = create(initialQuery, initialSelection)
        viewModel.insert(symbol: "?")
        #expect(viewModel.query == expectedQuery)
        #expect(viewModel.selection == expectedSelection)
    }
    
    @Test("Insert at position 0")
    func insertPositionZero(){
        let initialQuery = "moonstarer"
        let initialSelection : TextSelection = TextSelection(insertionPoint: initialQuery.startIndex)
        let expectedQuery = "?moonstarer"
        let expectedSelection = TextSelection(insertionPoint: expectedQuery.index(expectedQuery.startIndex, offsetBy: 1))

        let viewModel = create(initialQuery, initialSelection)
        viewModel.insert(symbol: "?")
        #expect(viewModel.query == expectedQuery)
        #expect(viewModel.selection == expectedSelection)

    }

    @Test("Insert in the middle of the query")
    func insertMiddle(){
        let initialQuery = "moonstarer"
        let initialSelection : TextSelection = TextSelection(insertionPoint: initialQuery.index(initialQuery.startIndex, offsetBy: 4))
        let expectedQuery = "moon@starer"
        let expectedSelection = TextSelection(insertionPoint: expectedQuery.index(expectedQuery.startIndex, offsetBy: 5))

        let viewModel = create(initialQuery, initialSelection)
        viewModel.insert(symbol: "@")
        #expect(viewModel.query == expectedQuery)
        #expect(viewModel.selection == expectedSelection)
    }

    @Test("Insert at the end of the query")
    func insertEnd(){
        let initialQuery = "moonstarer"
        let initialSelection : TextSelection = TextSelection(insertionPoint: initialQuery.endIndex)
        let expectedQuery = "moonstarer?"
        let expectedSelection = TextSelection(insertionPoint: expectedQuery.endIndex)

        let viewModel = create(initialQuery, initialSelection)
        viewModel.insert(symbol: "?")
        #expect(viewModel.query == expectedQuery)
        #expect(viewModel.selection == expectedSelection)
    }

    @Test("Insert with all selected")
    func insertSelectedAll(){
        let initialQuery = "moonstarer"
        let initialSelection : TextSelection = TextSelection(range: initialQuery.startIndex ..< initialQuery.endIndex)
        let expectedQuery = "?"
        let expectedSelection = TextSelection(insertionPoint: expectedQuery.endIndex)

        let viewModel = create(initialQuery, initialSelection)
        viewModel.insert(symbol: "?")
        #expect(viewModel.query == expectedQuery)
        #expect(viewModel.selection == expectedSelection)
    }

    @Test("Insert with one char selected")
    func insertSelectedOne(){
        let initialQuery = "moonstarer"
        let start = initialQuery.index(initialQuery.startIndex, offsetBy: 4)
        let end = initialQuery.index(initialQuery.startIndex, offsetBy: 5)
        let initialSelection : TextSelection = TextSelection(range: start ..< end)
        let expectedQuery = "moon?tarer"
        let expectedSelection = TextSelection(insertionPoint: expectedQuery.index(expectedQuery.startIndex, offsetBy: 5))

        let viewModel = create(initialQuery, initialSelection)
        viewModel.insert(symbol: "?")
        #expect(viewModel.query == expectedQuery)
        #expect(viewModel.selection == expectedSelection)
    }

    @Test("Insert with two chars selected")
    func insertSelectedTwoChars(){
        let initialQuery = "moonstarer"
        let start = initialQuery.index(initialQuery.startIndex, offsetBy: 3)
        let end = initialQuery.index(initialQuery.startIndex, offsetBy: 5)
        let initialSelection : TextSelection = TextSelection(range: start ..< end)
        let expectedQuery = "moo?tarer"
        let expectedSelection = TextSelection(insertionPoint: expectedQuery.index(expectedQuery.startIndex, offsetBy: 4))

        let viewModel = create(initialQuery, initialSelection)
        viewModel.insert(symbol: "?")
        #expect(viewModel.query == expectedQuery)
        #expect(viewModel.selection == expectedSelection)
    }

}


@Suite("SearchBarViewModel ShowMe Regression Tests")
struct SearchBarViewModelRegressionTests {
    
    @Test("Ensure that the selection is set to the end of the string")
    func showMeCrash(){
        let longString = "this is a longer string here"
        let shortString = "short"
        
        let viewModel = SearchBarViewModel()
        viewModel.showMe(example: longString)
        #expect(viewModel.selection == TextSelection(insertionPoint: longString.endIndex))

        //iOS 18 would crash as the text selection is out of bounds
        viewModel.showMe(example: shortString)
        #expect(viewModel.selection == TextSelection(insertionPoint: shortString.endIndex))
    }

    @Test("Ensure spaces are still converted to hyphens")
    func showMeHyphen(){
        let spacedString = "babylon 5 alien breed"
        let hyphenString = "babylon-5-alien-breed"
        
        let settings = Settings()
        let origValue = settings.spaceToQuestionMark
        settings.spaceToQuestionMark = false
        
        let viewModel = SearchBarViewModel()
        viewModel.showMe(example: spacedString)
        #expect(viewModel.query == spacedString)

        settings.spaceToQuestionMark = true
        viewModel.showMe(example: spacedString)
        #expect(viewModel.query == hyphenString)
        
        //Restore original value
        settings.spaceToQuestionMark = origValue
    }

}

