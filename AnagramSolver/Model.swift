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
    func stateChanged(newState : Model.States)
}
protocol WordSearchObserver : class
{
    func matchFound(match : String)
}
class Model : WordListCallback
{
    enum States : Int
    {
        case uninitialized,loading, ready, searching, finished
    }
    let TABLE_MAX_COUNT_TO_RELOAD = 20

    let wordList = WordList()
    let wordSearch : WordSearch
    var matches: [String] = []
    private let resourceName : String
    var state : States = States.uninitialized
    var query = ""
    
    //Need to use a dictionary, so I can use the string key to search on
    //Unable to search protocols due limitation in Swift, cannot use == on protocol!!!
    //see http://stackoverflow.com/questions/24888560/usage-of-protocols-as-array-types-and-function-parameters-in-swift
    var observersDictionary : [String : StateChangeObserver] = [:]
    weak var wordSearchObserver : WordSearchObserver!
    
    init(resourceName: String)
    {
        self.wordSearch = WordSearch(wordList: self.wordList)
        self.resourceName = resourceName
    }
    
    func addObserver(name: String, observer : StateChangeObserver)
    {
        observersDictionary[name]=observer
    }
    
    func removeObserver(name: String)
    {
        observersDictionary.removeValueForKey(name)
    }


    func loadDictionary()
    {
        changeState(States.loading)
        let path = NSBundle.mainBundle().pathForResource(resourceName, ofType: "txt")
        var possibleContent = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        
        if let content = possibleContent
        {
            let words = content.componentsSeparatedByString("\n")
            self.wordList.wordlist = words
        }
        changeState(States.ready)
    }
    
    func changeState(state: States)
    {
        println("State: \(state.rawValue)")
        for (_,observer) in observersDictionary
        {
            observer.stateChanged(state)
        }
    }
    
    func validateQuery(query : String) ->Bool
    {
        return true
    }
    func stop()
    {
        self.wordList.stopSearch()
    }
    func search()
    {
        changeState(States.searching)
        matches.removeAll(keepCapacity: true)
        var processedQuery = self.wordSearch.preProcessQuery(query)
        let searchType = self.wordSearch.getQueryType(processedQuery)
        processedQuery = self.wordSearch.postProcessQuery(processedQuery, type: searchType)
        self.wordSearch.runQuery(processedQuery, type: searchType, callback: self)
        changeState(States.finished)
    }
    
    func update(result: String)
    {
        matches.append(result)
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
        builder+="www.pigdogbay.com"
        return builder
    }
    
}