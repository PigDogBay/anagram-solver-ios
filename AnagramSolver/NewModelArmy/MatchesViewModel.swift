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
    var matches : [String] = []

    init(query: String, engine : WordEngine) {
        print("MatchesVM init()")
        self.query = query
        self.engine = engine
        
        status = "18 Matches"
        matches.append("magic")
        matches.append("megan")
        matches.append("magee")
    }
    
    func getSectionTitle(rows : [String]) -> String {
        rows[0].length == 1 ? "1 letter" : "\(rows[0].length) letters"
    }

    func search(word : String){
        
    }
}
