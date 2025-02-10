//
//  SearchHistoryModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 06/02/2025.
//  Copyright © 2025 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

class SearchHistoryCardViewModel : ObservableObject {
    let historyModel : SearchHistoryModel

    init(_ historyModel : SearchHistoryModel){
        self.historyModel = historyModel
    }
    
    func clearHistory(){
        historyModel.clearSearchHistory()
        //Update UI
        objectWillChange.send()
    }
    
    ///If navigating back from the matches view controller, the view will not be recreated
    ///so need to Check if need to update the history
    func onAppear(){
        if historyModel.hasHistoryChanged(){
            objectWillChange.send()
        }
    }
}

class SearchHistoryModel {
    private static let SEARCH_HISTORY_MAX_ENTRIES = 5
    lazy private(set) var searchHistory = SearchHistoryUserDefaults().load()
    var isSearchHistoryEnabled = true
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
        if isSearchHistoryEnabled {
            searchHistory.add(query: query)
            //save it
            let persistence = SearchHistoryUserDefaults()
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
        let persistence = SearchHistoryUserDefaults()
        persistence.clear()
    }
    
    func dbgFillHistory(){
        let randomQuery = RandomQuery()
        for _ in 1...100 {
            searchHistory.add(query: randomQuery.anagram())
        }
        
    }
}
