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
    
    private var isDirty = false
    
    ///Converts the queries to markdown that the user can tap on
    ///Only takes the first 5 history entries
    var markdownLinks : [String] {
        if searchHistory.count < 5 {
            return []
        }
        return searchHistory
            .getHistory()
            .prefix(upTo: 5)
            .map {$0.trimmingCharacters(in: .whitespaces)}
            .map {"[\($0)](\($0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"}
    }

    func updateSearchHistory(query : String){
        if settings.isSearchHistoryEnabled {
            searchHistory.add(query: query)
            //save it
            let persistence = SearchHistoryPersistence()
            persistence.save(history: self.searchHistory)
            isDirty = true
        }
    }
    
    func hasHistoryChanged() -> Bool {
        let isChanged = isDirty
        isDirty = false
        return isChanged
    }
    
    func clearSearchHistory(){
        searchHistory.clear()
        let persistence = SearchHistoryPersistence()
        persistence.clear()
    }
}
