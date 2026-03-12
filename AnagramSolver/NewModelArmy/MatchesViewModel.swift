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

//Maybe add states for filter, showMe, results, user
enum SearchState {
    case ready, searching, finished
}

@Observable class MatchesViewModel {
    var query : String
    @ObservationIgnored let engine : WordEngine
    let filtersVM : FiltersViewModel
    let wordFormatter = WordFormatter()
    @ObservationIgnored var resultsListMode = ResultsListMode.empty
    @ObservationIgnored var grouped = [[String]]()
    @ObservationIgnored var matches : [String] = []
    var searchState : SearchState = .ready

    var status  : String {
        switch (searchState){
        case .ready:
            return "Ready"
        case .searching:
            return getSearchingStatusText()
        case .finished:
            return getFinishedStatusText()
        }
    }

    
    init(query: String, engine : WordEngine, filtersVM : FiltersViewModel) {
        print("MatchesVM init()")
        self.query = query
        self.engine = engine
        self.filtersVM = filtersVM
    }
    
    func getSectionTitle(rows : [String]) -> String {
        rows[0].length == 1 ? "1 letter" : "\(rows[0].length) letters"
    }

    func search(word : String){
        query = word
        if query == "" {
            searchState = .finished
            return
        }
        searchState = .searching
        engine.resetStop()
        let searchParser = SearchParser()
        let searchQuery = searchParser.parse(query: query)
        wordFormatter.newSearch(searchQuery)
        let filterPipeline = filtersVM.createChainedCallback(lastCallback: engine)
        matches.removeAll()
        Task {
            self.engine.combinedSearch(searchQuery, callback: filterPipeline)
            matches.append(contentsOf: engine.working)
            resultsListMode = calculateListMode()
            searchState = .finished
        }
    }
    
    private func getSearchingStatusText() -> String{
        if filtersVM.filterCount > 1 {
            return "Searching (\(filtersVM.filterCount) Filters Active)"
        }
        if filtersVM.filterCount > 0 {
            return "Searching (\(filtersVM.filterCount) Filter Active)"
        }
        return "Searching"
    }
    
    private func getFinishedStatusText() -> String{
        if query == "" {
            return ""
        }
        if filtersVM.filterCount > 0 {
            return "Matches: \(matches.count) Filters: \(filtersVM.filterCount)"
        }
        return "Matches: \(matches.count)"
    }
    
    private func calculateListMode() -> ResultsListMode {
        groupBySize()
        return grouped.count>1 ? .groupedByLength : .plain
    }
    
    ///Converts the matches array into multiple arrays where where strings are the same length
    private func groupBySize() {
        //Dictionary(grouping) does the hard word in creating the key - length, value - [string]
        //Interestingly the order as each match is added to it's array is preserved
        //so no need to do an A-Z sort on each array.
        //The keys are then sorted in descending order
        //The map then iterates over the sorted key/pairs returning the [string] values as [[string]]
        self.grouped = Dictionary(grouping: matches, by: {$0.length})
            .sorted (by: {$0.0 > $1.0})
            .map{$0.value}
    }


    
}
