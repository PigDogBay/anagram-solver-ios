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
    static let SEARCH_HISTORY_MAX_ENTRIES = 5
    lazy private(set) var searchHistory = SearchHistoryPersistence().load()
    let settings = Settings()
    
    var canShowSearchHistory : Bool {
            return settings.isSearchHistoryEnabled
    }
    
    private var isDirty = false
    
    ///Converts the queries to markdown that the user can tap on
    ///Only takes the first 5 history entries
    var markdownLinks : [String] {
        if searchHistory.count == 0 {
            return []
        }
        let maxEntries = min(SearchHistoryModel.SEARCH_HISTORY_MAX_ENTRIES,searchHistory.count)
        return searchHistory
            .getHistory()
            .prefix(upTo: maxEntries)
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
    
    func dbgFillHistory(){
        let randomQuery = RandomQuery()
        for _ in 1...100 {
            searchHistory.add(query: randomQuery.anagram())
        }
        
    }
}
