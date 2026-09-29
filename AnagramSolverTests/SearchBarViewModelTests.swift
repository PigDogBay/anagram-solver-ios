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
    
    ///Keyboard type B will convert three dots into an ellipsis
    ///The is now way yet to disable this behaviour in iOS27
    @Test("Converting …| to ...|")
    func updateQueryEllipsisCursorPos1(){
        let initial = "…"
        let expected = "..."
        let viewModel = SearchBarViewModel()
        //UITextfield will set query / selection values to the following
        viewModel.query = initial
        viewModel.selection = TextSelection(insertionPoint: initial.endIndex)
        
        viewModel.updateQuery(initial)
        #expect(viewModel.query == expected)
        #expect(viewModel.selection == TextSelection(insertionPoint: expected.endIndex))
    }
    
    @Test("Converting ab…| to ab...|")
    func updateQueryEllipsisCursorPos2(){
        let initial = "ab…"
        let expected = "ab..."
        let viewModel = SearchBarViewModel()
        //UITextfield will set query / selection values to the following
        viewModel.query = initial
        viewModel.selection = TextSelection(insertionPoint: initial.endIndex)

        viewModel.updateQuery(initial)
        #expect(viewModel.query == expected)
        #expect(viewModel.selection == TextSelection(insertionPoint: expected.endIndex))
    }

    @Test("Converting a…|b to a...|b")
    func updateQueryEllipsisCursorPos3(){
        let initialQuery = "a…b"
        let expectedQuery = "a...b"
        let viewModel = SearchBarViewModel()
        //UITextfield will set query to be a…b (via the binding) and then call onChange(){updateQuery}
        viewModel.query = initialQuery
        //Place cursor at a…|b
        viewModel.selection = TextSelection(insertionPoint: initialQuery.index(initialQuery.startIndex, offsetBy: 2))

        viewModel.updateQuery("a…b")
        #expect(viewModel.query == expectedQuery)
        //expect that the cursor will be placed a...|b
        #expect(viewModel.selection == TextSelection(insertionPoint: expectedQuery.index(expectedQuery.startIndex, offsetBy: 4)))
    }
    
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

