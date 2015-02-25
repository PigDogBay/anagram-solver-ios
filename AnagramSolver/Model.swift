//
//  Model.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 25/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

//To Do
//Enum of various states
//un-initialized, loading, loading done, ready, searching, search finished
//Use observer pattern so VC's can listen to state changes
class Model
{
    let wordList = WordList()
    var wordSearch : WordSearch!

    init()
    {
        self.wordSearch = WordSearch(wordList: self.wordList)
    }
    
    func loadDictionary()
    {
        let path = NSBundle.mainBundle().pathForResource("standard", ofType: "txt")
        var possibleContent = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        
        if let content = possibleContent
        {
            let words = content.componentsSeparatedByString("\n")
            self.wordList.wordlist = words
        }
    }
    
}