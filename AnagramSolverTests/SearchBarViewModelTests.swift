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

@Suite("SearchBarViewModel Update Query Tests")
struct SearchBarViewModelUpdateQueryTests {
    private struct UpdateQueryCase {
        let query: String
        let selection: TextSelection?
        let update: String
        let expected: String
        let expectedSelection: TextSelection?
    }
    
    private func verifyUpdateQuery(
        _ testCase: UpdateQueryCase,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let viewModel = SearchBarViewModel()
        viewModel.query = testCase.query
        viewModel.selection = testCase.selection

        viewModel.updateQuery(testCase.update)

        #expect(viewModel.query == testCase.expected, sourceLocation: sourceLocation)
        #expect(viewModel.selection == testCase.expectedSelection, sourceLocation: sourceLocation)
    }

    @Test("Empty query, nil selection, update with abc, expect \"\" nil")
    func updateEmptyNilWithEmpty() {
        verifyUpdateQuery(
            UpdateQueryCase(
                query: "",
                selection: nil,
                update: "",
                expected: "",
                expectedSelection: nil
            )
        )
    }

    @Test("Empty query, nil selection, update with abc, expect abc|")
    func updateEmptyNilWithABC() {
        verifyUpdateQuery(
            UpdateQueryCase(
                query: "",
                selection: nil,
                update: "abc",
                expected: "abc",
                expectedSelection: TextSelection(insertionPoint: "abc".endIndex)
            )
        )
    }
    
    @Test("abc| to abc|d")
    func updateToABCD() {
        verifyUpdateQuery(
            UpdateQueryCase(
                query: "abc",
                selection: TextSelection(insertionPoint: "abc".endIndex),
                update: "abcd",
                expected: "abcd",
                expectedSelection: TextSelection(insertionPoint: "abc".endIndex)
            )
        )
    }

    @Test("…| to ...|")
    func updateToEllipsis() {
        let settings = Settings()
        settings.fullStopToQuestionMark = false
        verifyUpdateQuery(
            UpdateQueryCase(
                query: "…",
                selection: TextSelection(insertionPoint: "…".endIndex),
                update: "…",
                expected: "...",
                expectedSelection: TextSelection(insertionPoint: "...".endIndex)
            )
        )
    }

    @Test("|… to |...")
    func updateToEllipsisStartIndex() {
        let settings = Settings()
        settings.fullStopToQuestionMark = false
        verifyUpdateQuery(
            UpdateQueryCase(
                query: "…",
                selection: TextSelection(insertionPoint: "…".startIndex),
                update: "…",
                expected: "...",
                expectedSelection: TextSelection(insertionPoint: "...".startIndex)
            )
        )
    }

    @Test("x…|x to x...|x")
    func updateToEllipsisXerox() {
        let settings = Settings()
        settings.fullStopToQuestionMark = false
        verifyUpdateQuery(
            UpdateQueryCase(
                query: "x…x",
                selection: TextSelection(insertionPoint: "x…".endIndex),
                update: "x…x",
                expected: "x...x",
                expectedSelection: TextSelection(insertionPoint: "x...".endIndex)
            )
        )
    }

    @Test("…| to ???|")
    func updateToEllipsisQM() {
        let settings = Settings()
        settings.fullStopToQuestionMark = true
        verifyUpdateQuery(
            UpdateQueryCase(
                query: "…",
                selection: TextSelection(insertionPoint: "…".endIndex),
                update: "…",
                expected: "???",
                expectedSelection: TextSelection(insertionPoint: "???".endIndex)
            )
        )
    }

    @Test("Space to ?")
    func updateToSpaceToQM() {
        let settings = Settings()
        settings.fullStopToQuestionMark = true
        settings.spaceToQuestionMark = true
        verifyUpdateQuery(
            UpdateQueryCase(
                query: "   ",
                selection: TextSelection(insertionPoint: "   ".endIndex),
                update: "   ",
                expected: "???",
                expectedSelection: TextSelection(insertionPoint: "???".endIndex)
            )
        )
    }

    @Test("ab|..|ef ab??|ef")
    func updateRange() {
        let settings = Settings()
        settings.fullStopToQuestionMark = true
        verifyUpdateQuery(
            UpdateQueryCase(
                query: "ab..ef",
                selection: TextSelection(range: "ab".endIndex..<"ab..".endIndex),
                update: "ab..ef",
                expected: "ab??ef",
                expectedSelection: TextSelection(insertionPoint: "ab??".endIndex)
            )
        )
    }

    @Test("ab.  | ab?|")
    func updateBadRange() {
        let settings = Settings()
        settings.fullStopToQuestionMark = true
        verifyUpdateQuery(
            UpdateQueryCase(
                query: "ab.",
                selection: TextSelection(insertionPoint: "ab.   ".endIndex),
                update: "ab.",
                expected: "ab?",
                expectedSelection: TextSelection(insertionPoint: "ab?".endIndex)
            )
        )
    }



}

@Suite("SearchBarViewModel Insert Symbol Tests")
struct SearchBarViewModelInsertTests {
    
    private func create(_ query: String, _ selection: TextSelection?) -> SearchBarViewModel {
        let viewModel = SearchBarViewModel()
        viewModel.query = query
        viewModel.selection = selection
        return viewModel
    }
   
    
    @Test("Inserting symbol with index out of range, appends to end")
    func insertSelectionOutOfRange() {
        let initialQuery = "abc"
        let initialSelection : TextSelection = TextSelection(insertionPoint: "abcdef".endIndex)
        let expectedQuery = "abc?"
        let expectedSelection = TextSelection(insertionPoint: expectedQuery.endIndex)

        let viewModel = create(initialQuery, initialSelection)
        viewModel.insert(symbol: "?")
        #expect(viewModel.query == expectedQuery)
        #expect(viewModel.selection == expectedSelection)
    }

    @Test("Inserting symbol with end index out of range, appends to end")
    func insertSelectionEndOutOfRange() {
        let initialQuery = "abc"
        let initialSelection : TextSelection = TextSelection(range: "abc".startIndex ..< "abcdef".endIndex)
        let expectedQuery = "abc?"
        let expectedSelection = TextSelection(insertionPoint: expectedQuery.endIndex)

        let viewModel = create(initialQuery, initialSelection)
        viewModel.insert(symbol: "?")
        #expect(viewModel.query == expectedQuery)
        #expect(viewModel.selection == expectedSelection)
    }


    @Test("Inserting symbol with start and end index out of range, appends to end")
    func insertSelectionStartOutOfRange() {
        let initialQuery = "abc"
        let initialSelection : TextSelection = TextSelection(range: "abcd".endIndex ..< "abcdef".endIndex)
        let expectedQuery = "abc?"
        let expectedSelection = TextSelection(insertionPoint: expectedQuery.endIndex)

        let viewModel = create(initialQuery, initialSelection)
        viewModel.insert(symbol: "?")
        #expect(viewModel.query == expectedQuery)
        #expect(viewModel.selection == expectedSelection)
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
        Settings().fullStopToQuestionMark = false
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
        Settings().fullStopToQuestionMark = false
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

