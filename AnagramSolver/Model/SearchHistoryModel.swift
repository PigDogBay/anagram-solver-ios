//
//  SearchHistoryModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 06/02/2025.
//  Copyright © 2025 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

class SearchHistoryRowViewModel : ObservableObject {
    let historyModel : SearchHistoryModel

    init(_ historyModel : SearchHistoryModel){
        self.historyModel = historyModel
    }
}

@Observable class SearchHistoryCardViewModel {
    let historyModel : SearchHistoryModel
    
    var history : [String] = []

    var isHistoryAvailable : Bool {
        return !history.isEmpty
    }

    init(_ historyModel : SearchHistoryModel){
        self.historyModel = historyModel
        history = historyModel.markdownLinks
    }
    
    func clearHistory(){
        historyModel.clearSearchHistory()
        history.removeAll()
    }
    
    func onAppear(){
        if historyModel.hasHistoryChanged() {
            history = historyModel.markdownLinks
        }
    }
}

class SearchHistoryModel {
    private static let SEARCH_HISTORY_MAX_ENTRIES = 5
    private let persistence : SearchHistoryPersistence
    lazy private(set) var searchHistory = persistence.load()
    var isSearchHistoryEnabled = true
    private var isDirty = false
    
    init(persistence: SearchHistoryPersistence, isSearchHistoryEnabled: Bool = true) {
        self.persistence = persistence
        self.isSearchHistoryEnabled = isSearchHistoryEnabled
    }
    
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
        persistence.clear()
        isDirty = true
    }
    
    func dbgFillHistory(){
        let randomQuery = RandomQuery()
        for _ in 1...100 {
            searchHistory.add(query: randomQuery.anagram())
        }
    }
}
