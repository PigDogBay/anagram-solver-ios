//
//  SearchHistoryModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 06/02/2025.
//  Copyright © 2025 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

class SearchHistoryModel {
    static let SEARCH_HISTORY_MIN_ENTRIES = 5
    lazy private(set) var searchHistory = SearchHistoryPersistence().load()
    let settings = Settings()
    
    var canShowSearchHistory : Bool {
        return searchHistory.count >= SearchHistoryModel.SEARCH_HISTORY_MIN_ENTRIES
            && settings.isSearchHistoryEnabled
    }

    func updateSearchHistory(query : String){
        if settings.isSearchHistoryEnabled {
            searchHistory.add(query: query)
            //save it
            let persistence = SearchHistoryPersistence()
            persistence.save(history: self.searchHistory)
        }
    }
    
    func clearSearchHistory(){
        searchHistory.clear()
        let persistence = SearchHistoryPersistence()
        persistence.clear()
    }
}
