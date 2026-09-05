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
    case empty, plain, groupedByLength, thesaurusAnagramGroup
}

@MainActor
@Observable
class MatchesViewModel {
    var query : String
    let model : Model
    
    @ObservationIgnored let engine : WordEngine
    @ObservationIgnored let filters : Filters
    @ObservationIgnored let wordFormatter = WordFormatter()
    @ObservationIgnored var resultsListMode = ResultsListMode.empty
    @ObservationIgnored var grouped = [[String]]()
    @ObservationIgnored var matches : [String] = []
    @ObservationIgnored var synonyms : [String] = []
    @ObservationIgnored let settings = Settings()

    var status  : String {
        switch (model.appState){
        case .ready:
            return "Ready"
        case .searching:
            return getSearchingStatusText()
        case .finished:
            return getFinishedStatusText()
        case .uninitialized:
            return ""
        case .loading:
            return "Loading..."
        case .error:
            return "App Error"
        case .cancelled:
            return "Search Stopped"
        }
    }
    
    var showShareButton : Bool {
        return model.appState == .finished
    }

    
    init(query: String, model : Model, filters : Filters) {
        self.query = query
        self.model = model
        self.engine = model.engine
        self.filters = filters
        
        //Apply settings
        wordFormatter.highlightColor = settings.highlight
        wordFormatter.isUpperCased = settings.useUpperCase
    }
    
    func onAppear(){
        if model.appState == .ready || model.appState == .cancelled {
            search(word: query)
            //Clear any filters if performing a new search (eg no active filters)
            //AND when auto clear filters is active
            if !filters.isActive && settings.autoClearFilters {
                filters.reset()
            }
        }
    }
    
    func getSectionTitle(rows : [String]) -> String {
        rows[0].length == 1 ? "1 letter" : "\(rows[0].length) letters"
    }

    func search(word : String){
        query = word
        if query == "" {
            model.appState = .finished
            return
        }
        engine.resetStop()
        let searchParser = SearchParser()
        let searchQuery = searchParser.parse(query: query)
        wordFormatter.newSearch(searchQuery)
        let filterPipeline = filters.isActive ? filters.createChainedCallback(lastCallback: engine) : engine
        matches.removeAll()
        synonyms.removeAll()
        grouped.removeAll()
        model.appState = .searching
        Task {
            //Run the search on a background thread so I don't block the Main UI thread
            //See issue #16
            let (newMatches, newSynonyms) = await Task.detached(priority: .userInitiated) { [engine, filterPipeline] in
                self.engine.combinedSearch(searchQuery, callback: filterPipeline)
                return (engine.working, engine.synonymWorking)
            }.value
            if engine.isStopped {
                //If the device lock button was pressed or the app has gone into the background
                //MatchesVM needs to indicate that the search has been cancelled
                //when the user returns to this app.
                model.appState = .cancelled
                //Exit, do not update the UI as the app may now be inactive, see #16
                return
            }
            matches.append(contentsOf: newMatches)
            synonyms.append(contentsOf: newSynonyms)
            resultsListMode = calculateListMode()
            model.searchHistoryModel.updateSearchHistory(query: query)
            model.appState = .finished
        }
    }
    
    private func getSearchingStatusText() -> String{
        if filters.isActive && filters.filterCount > 1 {
            return "Searching (\(filters.filterCount) Filters Active)"
        }
        if filters.isActive && filters.filterCount > 0 {
            return "Searching (\(filters.filterCount) Filter Active)"
        }
        return "Searching"
    }
    
    private func getFinishedStatusText() -> String{
        if query == "" {
            return ""
        }
        if filters.isActive && filters.filterCount > 0 {
            return "Matches: \(matches.count + synonyms.count) Filters: \(filters.filterCount)"
        }
        return "Matches: \(matches.count + synonyms.count)"
    }
    
    private func calculateListMode() -> ResultsListMode {
        if engine.synonymWorking.count > 0 {
            return .thesaurusAnagramGroup
        }
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
    
    func flattenMatches()->String {
        return matches.reduce(""){result, next in result+next+"\n"}
    }


    func share()->[String]
    {
        var builder = "-Anagram Solver-\n\nQuery:\n\(self.query)\n\n"
        let filterDescriptions = filters.activeFiltersDescriptions()
        if filters.isActive && !filterDescriptions.isEmpty {
            builder+="Filters:\n"
            builder.append(filterDescriptions
                .reduce("") {result, next in result+next+"\n"}
            )
            builder.append("\n")
        }
        builder+="Matches:\n"
        builder.append(flattenMatches())
        builder+="\nAvailable on the App Store\n"
        builder+=Strings.itunesAppURL
        return [builder]
    }
}
