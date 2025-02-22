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
    @Published var showHistory : Bool

    init(_ historyModel : SearchHistoryModel){
        self.historyModel = historyModel
        self.showHistory = historyModel.isSearchHistoryEnabled
    }

    func onAppear(){
        if showHistory != historyModel.isSearchHistoryEnabled {
            showHistory = historyModel.isSearchHistoryEnabled
        }
    }
}

class SearchHistoryCardViewModel : ObservableObject {
    let historyModel : SearchHistoryModel
    @Published var showHistory : Bool
    
    var isHistoryAvailable : Bool {
        return historyModel.searchHistory.count>0
    }

    init(_ historyModel : SearchHistoryModel){
        self.historyModel = historyModel
        self.showHistory = historyModel.isSearchHistoryEnabled
    }
    
    func clearHistory(){
        historyModel.clearSearchHistory()
        //Update UI
        objectWillChange.send()
    }
    
    ///If navigating back from the matches view controller, the view will not be recreated
    ///so need to Check if need to update the history
    ///Note that the ScrollView in card tips will cause the view to be re-created, however
    ///the list in TipsView will not be. This view model will always ensure the view is updated
    ///and not rely on a side effect in ScrollView, this VM does not causes any excessive UI updates (ScrollView will tho)
    func onAppear(){
        if showHistory != historyModel.isSearchHistoryEnabled {
            showHistory = historyModel.isSearchHistoryEnabled
        }
        if historyModel.hasHistoryChanged(){
            objectWillChange.send()
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
    }
    
    func dbgFillHistory(){
        let randomQuery = RandomQuery()
        for _ in 1...100 {
            searchHistory.add(query: randomQuery.anagram())
        }
    }
}
