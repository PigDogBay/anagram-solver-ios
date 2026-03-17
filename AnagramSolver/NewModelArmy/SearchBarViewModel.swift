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
    @ObservationIgnored let settings = Settings()
    @ObservationIgnored let searchParser = SearchParser()
    
    var showValidationError = false
    
    func isValid() -> Bool{
        let clean = searchParser.clean(query)
        return clean.length>0
    }
    
    func showMe(example : String){
        let casedQuery = settings.useUpperCase ? example.uppercased() : example
        if settings.spaceToQuestionMark {
            //Convert spaces to -, otherwise they will be converted to ? in updateQuery
            self.query = casedQuery.replacingOccurrences(of: " ", with: "-")
        } else {
            self.query = casedQuery
        }
    }

    func updateQuery (_ newValue : String) {
        var working = newValue
        if settings.spaceToQuestionMark {
            working = working.replacingOccurrences(of: " ", with: "?")
        }
        if settings.fullStopToQuestionMark {
            working = working.replacingOccurrences(of: ".", with: "?")
        }
        if query != working {
           query = working
        }
    }
}
