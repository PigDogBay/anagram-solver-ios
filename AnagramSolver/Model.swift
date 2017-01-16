//
//  Model.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 25/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

protocol StateChangeObserver
{
    func stateChanged(_ newState : Model.States)
}
protocol WordSearchObserver : class
{
    func matchFound(_ match : String)
}
class Model : WordListCallback, IAPDelegate
{
    //Singleton
    static let sharedInstance = Model()
    
    class func getAppUrl()->String
    {
        return "itms-apps://itunes.apple.com/app/id973923699"
    }
    class func getAppWebUrl()->String
    {
        return "http://itunes.apple.com/app/id973923699"
    }
    enum States : Int
    {
        case uninitialized,loading, ready, searching, finished
    }
    fileprivate let TABLE_MAX_COUNT_TO_RELOAD = 20
    fileprivate var resultsCount = 0
    open var resultsLimit = 500

    let wordList = WordList()
    let wordSearch : WordSearch
    let wordFormatter = WordFormatter()
    var matches: [String] = []
    var state : States = States.uninitialized
    var query = ""
    let settings = Settings()
    let ads = Ads()
    let iap : IAPInterface
    
    //Need to use a dictionary, so I can use the string key to search on
    //Unable to search protocols due limitation in Swift, cannot use == on protocol!!!
    //see http://stackoverflow.com/questions/24888560/usage-of-protocols-as-array-types-and-function-parameters-in-swift
    var observersDictionary : [String : StateChangeObserver] = [:]
    weak var wordSearchObserver : WordSearchObserver!
    
    fileprivate init()
    {
        self.wordSearch = WordSearch(wordList: self.wordList)
        self.iap = IAPFactory.createIAPInterface()
        self.iap.observable.addObserver("model", observer: self)
    }
    
    func getWord(atIndex index : Int) -> String? {
        if index>=0 && index < matches.count {
            return matches[index]
        }
        return nil
    }
    
    func addObserver(_ name: String, observer : StateChangeObserver)
    {
        observersDictionary[name]=observer
    }
    
    func removeObserver(_ name: String)
    {
        observersDictionary.removeValue(forKey: name)
    }

    func unloadDictionary()
    {
        self.wordList.wordlist = nil
        changeState(States.uninitialized)
    }
    
    func loadDictionary(_ resourceName: String)
    {
        changeState(States.loading)
        let path = Bundle.main.path(forResource: resourceName, ofType: "txt")
        let possibleContent = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        if let content = possibleContent
        {
            let words = content.components(separatedBy: "\n")
            self.wordList.wordlist = words
        }
        changeState(States.ready)
    }
    
    func changeState(_ newState: States)
    {
        self.state = newState
        for (_,observer) in observersDictionary
        {
            observer.stateChanged(state)
        }
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
        matches.removeAll(keepingCapacity: true)
    }
    func search()
    {
        changeState(States.searching)
        resultsCount = 0
        applySettings()
        var processedQuery = query;
        processedQuery = self.wordSearch.preProcessQuery(processedQuery)
        let searchType = self.wordSearch.getQueryType(processedQuery)
        processedQuery = self.wordSearch.postProcessQuery(processedQuery, type: searchType)
        wordFormatter.newSearch(processedQuery, searchType)
        self.wordSearch.runQuery(processedQuery, type: searchType, callback: self)
        changeState(States.finished)
    }
    
    func update(_ result: String)
    {
        matches.append(result)
        resultsCount = resultsCount + 1
        if resultsCount == resultsLimit
        {
            self.wordList.stopSearch()
        }
        //only update the table until we have enough items to fill the screen
        if self.matches.count<self.TABLE_MAX_COUNT_TO_RELOAD
            && self.wordSearchObserver != nil
        {
            self.wordSearchObserver.matchFound(result)
        }
    }
    
    func share()->String
    {
        var builder = "-Anagram Solver-\n\nQuery:\n\(self.query)\n\nMatches:\n"
        for s in matches
        {
            builder = builder + s + "\n"
        }
        builder+="\nAvailable on the App Store\n"
        builder+=Model.getAppWebUrl()
        return builder
    }
    
    func isReady() -> Bool
    {
        if States.finished == self.state
        {
            state = States.ready
        }
        return States.ready == self.state
    }
    
    func stdMode()
    {
        settings.isProMode = false
        self.unloadDictionary()
        self.ads.reset()
    }
    func proMode()
    {
        settings.isProMode = true
        self.unloadDictionary()
        self.ads.noAds()
    }
    
    func applySettings(){
        self.wordFormatter.highlightColor = self.settings.highlight
        self.resultsLimit = self.settings.resultsLimit
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
