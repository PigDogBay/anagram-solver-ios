//
//  SearchBarViewModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 11/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUI
import SwiftUtils

@Observable class SearchBarViewModel {
    var query = ""
    var selection : TextSelection?
    @ObservationIgnored let settings = Settings()
    @ObservationIgnored let searchParser = SearchParser()
    
    var showValidationError = false

    // Symbol Bar symbols and their corresponding SF Symbol names
    let symbols = [
        ("?", "questionmark"),
        ("+", "plus"),
        ("*", "asterisk"),
        ("-", "minus"),
        ("$", "dollarsign"),
        ("@", "at"),
        ("!","exclamationmark")
    ]

    ///The query TextField is only bound to selection on iOS 26+
    ///On iOS 18, SwiftUI crashes when the selection and text are briefly out of sync (eg when accessibility reads the TextField)
    ///Without the binding, selection would never track the cursor, so it is kept nil and symbols are appended instead
    static var isSelectionSupported : Bool {
        if #available(iOS 26, *) { return true }
        return false
    }

    func isValid() -> Bool{
        let clean = searchParser.clean(query)
        return clean.length>0
    }
    
    ///When programmatically setting the query, selection also needs updating
    ///If selection is not updated, this will cause a crash in iOS 18
    func setQuery(_ newValue: String) {
        query = newValue
        moveCursor(to: newValue.endIndex)
    }

    private func moveCursor(to index : String.Index) {
        selection = Self.isSelectionSupported ? TextSelection(insertionPoint: index) : nil
    }

    func showMe(example : String){
        let casedQuery = settings.useUpperCase ? example.uppercased() : example
        //Convert spaces to -, otherwise they will be converted to ? in updateQuery
        setQuery(settings.spaceToQuestionMark
            ? casedQuery.replacingOccurrences(of: " ", with: "-")
            : casedQuery)
    }

    ///The Query TextField is bound to query and selection
    ///When the user types, query/selection will be updated and then this function will be called via onChange
    ///
    ///Converts ellipsis to three dots ...
    ///Handles converting space/. to ?
    ///Ensures the cursor position is correctly updated
    func updateQuery (_ newValue : String) {
        let working = normalize(newValue)
        guard working != query else { return }
        
        if !isValid(selection, in: query){
            query = working
            moveCursor(to: working.endIndex)
            return
        }
        
        // Where was the cursor (end of selection), in terms of the normalized text?
        var cursor = working.count
        if let selection, case .selection(let r) = selection.indices {
            cursor = normalize(String(query[..<r.upperBound])).count
        }
        query = working
        let idx = working.index(working.startIndex, offsetBy: min(cursor, working.count))
        moveCursor(to: idx)
    }
    
    /// The .webSearch (Allow Dictation) keyboard has smart punctuation so,
    /// Convert ellipsis back to three periods
    private func normalize(_ s: String) -> String {
        var w = s.replacingOccurrences(of: "…", with: "...")
        if settings.spaceToQuestionMark { w = w.replacingOccurrences(of: " ", with: "?") }
        if settings.fullStopToQuestionMark { w = w.replacingOccurrences(of: ".", with: "?") }
        return w
    }
    
    ///Inserts the symbol at the current cursor position, also takes account of the any text selection
    func insert(symbol : String){
        guard Self.isSelectionSupported,
            let selection,
            case .selection(let range) = selection.indices,
            isValid(selection, in: query) else {
            // No tracked selection (e.g. field not focused or iOS 18) — fall back to append
            setQuery(query + symbol)
            return
        }
        // Move the cursor to just after the inserted text
        let offset = query.distance(from: query.startIndex, to: range.lowerBound)

        // If there's an actual selection, replace it; otherwise range is a collapsed cursor
        query.replaceSubrange(range, with: symbol)

        let newIndex = query.index(query.startIndex, offsetBy: offset + symbol.count)
        moveCursor(to: newIndex)
    }

    /// Validates whether a `TextSelection` falls within the valid range of a given string.
    /// - Parameters:
    ///   - selection: The optional `TextSelection` to validate.
    ///   - text: The target string being selected.
    /// - Returns: `true` if the selection is non-nil and completely within the string's bounds; otherwise `false`.
    func isValid(_ selection: TextSelection?, in text: String) -> Bool {
        guard let selection,
              case .selection(let range) = selection.indices else { return false }

        return range.lowerBound >= text.startIndex
            && range.upperBound <= text.endIndex
            && range.lowerBound.samePosition(in: text) != nil
            && range.upperBound.samePosition(in: text) != nil
    }
}
