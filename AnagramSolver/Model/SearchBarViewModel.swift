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

    func isValid() -> Bool{
        let clean = searchParser.clean(query)
        return clean.length>0
    }
    
    ///When programmatically setting the query, selection also needs updating
    ///If selection is not updated, this will cause a crash in iOS 18
    func setQuery(_ newValue: String) {
        query = newValue
        selection = TextSelection(insertionPoint: newValue.endIndex)
    }

    func showMe(example : String){
        let casedQuery = settings.useUpperCase ? example.uppercased() : example
        //Convert spaces to -, otherwise they will be converted to ? in updateQuery
        setQuery(settings.spaceToQuestionMark
            ? casedQuery.replacingOccurrences(of: " ", with: "-")
            : casedQuery)
    }

    func updateQuery (_ newValue : String) {
        let working = normalize(newValue)
        guard working != query else { return }
        query = working
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
        guard let selection, case .selection(let range) = selection.indices else {
            // No tracked selection (e.g. field not focused) — fall back to append
            setQuery(query + symbol)
            return
        }
        // Move the cursor to just after the inserted text
        let offset = query.distance(from: query.startIndex, to: range.lowerBound)

        // If there's an actual selection, replace it; otherwise range is a collapsed cursor
        query.replaceSubrange(range, with: symbol)

        let newIndex = query.index(query.startIndex, offsetBy: offset + symbol.count)
        self.selection = TextSelection(insertionPoint: newIndex)
    }
}
