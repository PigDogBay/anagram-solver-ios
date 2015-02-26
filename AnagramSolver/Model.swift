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
class Model
{
    enum States : Int
    {
        case uninitialized,loading, ready, searching, finished
    }
    
    let wordList = WordList()
    let wordSearch : WordSearch
    private let resourceName : String
    var state : States = States.uninitialized
    //Need to use a dictionary, so I can use the string key to search on
    //Unable to search protocols due limitation in Swift, cannot use == on protocol!!!
    //see http://stackoverflow.com/questions/24888560/usage-of-protocols-as-array-types-and-function-parameters-in-swift
    var observersDictionary : [String : StateChangeObserver] = [:]

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
        for (_,observer) in observersDictionary
        {
            observer.stateChanged(state)
        }
    }
    
    func validateQuery(query : String) ->Bool
    {
        return true
    }
    
}