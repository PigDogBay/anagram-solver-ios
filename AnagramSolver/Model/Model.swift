//
//  Model.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 25/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

class Model : WordListCallback, IAPDelegate, WordDictionary
{
    //Singleton
    static let sharedInstance = Model()
    
    //Need to check if user changes the word list setting, so cache it here
    var wordListName = ""
    var resultsLimit = 5000
    //Flag for one time load of the phrases word list
    private var loadPhrases = true

    let appState = AppStateObservable()
    let wordSearch : WordSearch
    let searchParser = SearchParser()
    lazy private(set) var searchHistoryModel =
    {
        SearchHistoryModel(persistence: SearchHistoryUserDefaults(),
                           isSearchHistoryEnabled: self.settings.isSearchHistoryEnabled)
    }()
    let wordFormatter = WordFormatter()
    let matches = Matches()
    var query = ""
    var casedQuery : String {
        return settings.useUpperCase ? query.uppercased() : query
    }
    var distinctMatchesOnly = false
    let settings = Settings()
    let ads = Ads()
    let ratings = Ratings(appId: Strings.appId)
    let iap : IAPInterface
    let filter : Filter
    let filterFactory : WordListCallbackAbstractFactory
    private var nabuSearch : Search? = nil
    var nabuLookUp : NabuLookUp? = nil
    ///Store lookUpResult for DefinitionView
    var lookUpResult : LookUpResult = LookUpResult(word: "", definitions: [])
    
    init()
    {
        filter = Filter()
        filterFactory = FilterFactory(filter: filter)
        self.wordSearch = WordSearch()
        self.iap = IAPFactory.createIAPInterface()
        self.iap.observable.addObserver("model", observer: self)
        applySettings()
    }
    
    func unloadDictionary()
    {
        wordSearch.unloadDictionary()
        appState.appState = .uninitialized
    }
    
    func loadDictionary() async
	{
        appState.appState = .loading
        do {
            try await wordSearch.loadDictionary(resource: wordListName)
            if (self.loadPhrases){
                try await self.wordSearch.loadPhrases(resource: "phrases")
                self.loadPhrases = false
            }
            //Load Nabu database, takes less than 1ms
            if self.nabuSearch == nil {
                if let db = NabuDatabase.open(bundleName: "nabu") {
                    let nabu = NabuSearch(db)
                    self.nabuSearch = nabu
                    self.nabuLookUp = NabuLookUp(nabu)
                }
            }
            appState.appState = .ready
        } catch {
            appState.appState = .error
        }
    }
    
    func setAndValidateQuery( _ raw : String) ->Bool
    {
        filter.query = raw
        self.query = searchParser.clean(raw)
        return self.query.length>0
    }
    func stop()
    {
        wordSearch.stop()
    }
    func prepareToSearch()
    {
        filter.reset()
        matches.removeAll()
    }
    func prepareToFilterSearch(){
        let validated = searchParser.clean(filter.query)
        if validated.length>0 {
            self.query = validated
        } else {
            //reset the filter query
            filter.query = query
        }
        matches.removeAll()
        appState.appState = .ready
    }
    
    func search()
    {
        appState.appState = .searching
        let searchQuery = searchParser.parse(query: query)
        //Need to remove any duplicate matches for two-word anagrams
        distinctMatchesOnly = searchQuery.searchType == .twoWordAnagram
        wordFormatter.newSearch(searchQuery)
        let filterPipeline = filterFactory.createChainedCallback(lastCallback: self)
        filter.updateFilterCount()
        self.wordSearch.runQuery(searchQuery, callback: filterPipeline)
        searchHistoryModel.updateSearchHistory(query: query)
        appState.appState = .finished
    }
    
    func update(_ result: String)
    {
        matches.matchFound(match: result, distinct: distinctMatchesOnly)
        if matches.count == resultsLimit
        {
            wordSearch.stop()
        }
    }
    
    func share()->String
    {
        var builder = "-Anagram Solver-\n\nQuery:\n\(self.query)\n\nMatches:\n"
        builder.append(matches.flatten())
        builder+="\nAvailable on the App Store\n"
        builder+=Strings.itunesAppURL
        return builder
    }

    func copyAll()->String
    {
        return matches.flatten()
    }
    
    func applySettings(){
        self.wordFormatter.highlightColor = self.settings.highlight
        self.wordFormatter.isUpperCased = self.settings.useUpperCase
        self.resultsLimit = self.settings.resultsLimit
        self.wordListName = settings.wordList
        self.wordSearch.findSubAnagrams = settings.showSubAnagrams
        self.searchHistoryModel.isSearchHistoryEnabled = settings.isSearchHistoryEnabled
    }
    
    func checkForSettingsChange(){
        let oldValue = wordListName
        applySettings()
        if oldValue != wordListName{
            //Use Pro Word list setting has changed
            appState.appState = .uninitialized
        }
    }
    //MARK:- WordDictionary implementation
    func lookUpDefinition(_ word : String) -> LookUpResult {
        lookUpResult = nabuLookUp?.lookUp(word: word) ?? LookUpResult(word: "", definitions: [])
        return lookUpResult
    }
    
    //MARK:- IAPDelegate
    func productsRequest(){
        //list of products received - do nothing
        //print("Model-IAPDelegate-products request")
    }
    func purchaseRequest(_ productID : String){
        //purchase successful, store in NSDefaults
        //print("Model-IAPDelegate-purchaseRequest \(productID)")
        settings.isProMode = true
    }
    func restoreRequest(_ productID : String){
        //purchase successful, store in NSDefaults
        //print("Model-IAPDelegate-restore request \(productID)")
        settings.isProMode = true
    }
    func purchaseFailed(_ productID : String){
        //purchase failed - do nothing here
        //print("Model-IAPDelegate-purchase failed \(productID)")
    }

    
}
