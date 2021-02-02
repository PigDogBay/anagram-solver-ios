//
//  Model.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 25/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

class Model : WordListCallback, IAPDelegate
{
    //Singleton
    static let sharedInstance = Model()
    
    //Need to check if user changes the word list setting, so cache it here
    var wordListName = ""
    var resultsLimit = 5000

    let appState = AppStateObservable()
    let wordSearch : WordSearch
    let wordFormatter = WordFormatter()
    let matches = Matches()
    var query = ""
    let settings = Settings()
    let ads = Ads()
    let ratings = Ratings(appId: Strings.appId)
    let iap : IAPInterface
    let filter : Filter
    let filterFactory : WordListCallbackAbstractFactory
    
    private init()
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
        wordSearch.clearWords()
        appState.appState = .uninitialized
    }
    
    func loadDictionary()
    {
        appState.appState = .loading
        if let path = Bundle.main.path(forResource: wordListName, ofType: "txt"),
           let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) {
            let words = content.components(separatedBy: "\n")
            wordSearch.set(words: words)
            appState.appState = .ready
        } else {
            appState.appState = .error
        }
    }
    
    func setAndValidateQuery( _ raw : String) ->Bool
    {
        filter.query = raw
        self.query = wordSearch.clean(raw)
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
        let validated = wordSearch.clean(filter.query)
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
        var processedQuery = query
        processedQuery = self.wordSearch.preProcessQuery(processedQuery)
        let searchType = self.wordSearch.getQueryType(processedQuery)
        processedQuery = self.wordSearch.postProcessQuery(processedQuery, type: searchType)
        wordFormatter.newSearch(processedQuery, searchType)
        let filterPipeline = filterFactory.createChainedCallback(lastCallback: self)
        filter.updateFilterCount()
        self.wordSearch.runQuery(processedQuery, type: searchType, callback: filterPipeline)
        appState.appState = .finished
    }
    
    func update(_ result: String)
    {
        matches.matchFound(match: result)
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
        self.resultsLimit = self.settings.resultsLimit
        self.wordListName = settings.wordList
        //Enabled now for standard and pro versions of the app
        self.wordSearch.findCodewords = true
        self.wordSearch.findThreeWordAnagrams = true
        self.wordSearch.findSubAnagrams = settings.showSubAnagrams
    }
    func checkForSettingsChange(){
        let oldValue = wordListName
        applySettings()
        if oldValue != wordListName{
            //Use Pro Word list setting has changed
            appState.appState = .uninitialized
        }
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
