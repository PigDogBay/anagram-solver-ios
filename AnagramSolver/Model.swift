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
    static let appId = "id973923699"

    class func getAppWebUrl()->String
    {
        return "https://itunes.apple.com/app/id973923699"
    }
    fileprivate var resultsCount = 0
    //Need to check if user changes the word list setting, so cache it here
    fileprivate var useProWordList = false
    open var resultsLimit = 500

    let appState = AppStateObservable()
    let wordList = WordList()
    let wordSearch : WordSearch
    let wordFormatter = WordFormatter()
    let matches = Matches()
    var query = ""
    let settings = Settings()
    let ads = Ads()
    let ratings = Ratings(appId: appId)
    let iap : IAPInterface
    let filter : Filter
    let filterFactory : WordListCallbackAbstractFactory
    
    fileprivate init()
    {
        filter = Filter()
        filterFactory = FilterFactory(filter: filter)
        self.wordSearch = WordSearch(wordList: self.wordList)
        self.iap = IAPFactory.createIAPInterface()
        self.iap.observable.addObserver("model", observer: self)
        applySettings()
    }
    
    func getWord(atIndex index : Int) -> String? {
        if index>=0 && index < matches.count {
            return matches[index]
        }
        return nil
    }
    
    func unloadDictionary()
    {
        self.wordList.wordlist = nil
        appState.appState = .uninitialized
    }
    
    func loadDictionary(_ resourceName: String)
    {
        appState.appState = .loading
        let path = Bundle.main.path(forResource: resourceName, ofType: "txt")
        let possibleContent = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        if let content = possibleContent
        {
            let words = content.components(separatedBy: "\n")
            self.wordList.wordlist = words
        }
        appState.appState = .ready
    }
    
    func setAndValidateQuery( _ raw : String) ->Bool
    {
        self.query = wordSearch.clean(raw)
        return self.query.length>0
    }
    func stop()
    {
        self.wordList.stopSearch()
    }
    func prepareToSearch()
    {
        filter.reset()
        matches.removeAll()
    }
    func prepareToFilterSearch(){
        matches.removeAll()
        appState.appState = .ready
    }
    
    func search()
    {
        appState.appState = .searching
        resultsCount = 0
        var processedQuery = query;
        processedQuery = self.wordSearch.preProcessQuery(processedQuery)
        let searchType = self.wordSearch.getQueryType(processedQuery)
        processedQuery = self.wordSearch.postProcessQuery(processedQuery, type: searchType)
        wordFormatter.newSearch(processedQuery, searchType)
        let filterPipeline = filterFactory.createChainedCallback(lastCallback: self)
        self.wordSearch.runQuery(processedQuery, type: searchType, callback: filterPipeline)
        appState.appState = .finished
    }
    
    func update(_ result: String)
    {
        matches.matchFound(match: result)
        resultsCount = resultsCount + 1
        if resultsCount == resultsLimit
        {
            self.wordList.stopSearch()
        }
    }
    
    func share()->String
    {
        var builder = "-Anagram Solver-\n\nQuery:\n\(self.query)\n\nMatches:\n"
        builder.append(matches.flatten())
        builder+="\nAvailable on the App Store\n"
        builder+=Model.getAppWebUrl()
        return builder
    }

    func copyAll()->String
    {
        return matches.flatten()
    }

    func stdMode()
    {
        settings.isProMode = false
        self.applySettings()
    }
    func proMode()
    {
        settings.isProMode = true
        self.applySettings()
    }
    
    func applySettings(){
        self.wordFormatter.highlightColor = self.settings.highlight
        self.resultsLimit = self.settings.resultsLimit
        self.useProWordList = settings.useProWordList
        self.wordSearch.findCodewords = settings.isProMode
        self.wordSearch.findThreeWordAnagrams = settings.isProMode
        self.wordSearch.findSubAnagrams = settings.showSubAnagrams
    }
    func checkForSettingsChange(){
        //do we need the synchronize?
        UserDefaults.standard.synchronize()
        let oldValue = useProWordList
        applySettings()
        if oldValue != useProWordList{
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
        proMode()
    }
    func restoreRequest(_ productID : String){
        //purchase successful, store in NSDefaults
        //print("Model-IAPDelegate-restore request \(productID)")
        proMode()
    }
    func purchaseFailed(_ productID : String){
        //purchase failed - do nothing here
        //print("Model-IAPDelegate-purchase failed \(productID)")
    }

    
}
