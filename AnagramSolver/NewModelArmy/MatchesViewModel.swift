//
//  MatchesViewModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 12/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//


import SwiftUI
import SwiftUtils

enum ResultsListMode {
    case empty, plain, groupedByLength
}

@Observable class MatchesViewModel {
    var query : String
    @ObservationIgnored let engine : WordEngine
    let wordFormatter = WordFormatter()

    var status  = ""
    @ObservationIgnored var resultsListMode = ResultsListMode.empty
    @ObservationIgnored var grouped = [[String]]()

    init(query: String, engine : WordEngine) {
        print("MatchesVM init()")
        self.query = query
        self.engine = engine
    }
}
