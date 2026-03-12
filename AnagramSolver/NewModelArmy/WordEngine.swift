//
//  WordEngine.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 18/05/2022.
//  Copyright © 2022 Mark Bailey. All rights reserved.
//

import Foundation
import SwiftUtils

class WordEngine : WordListCallback {
    var showSynonyms = true
    let wordSearch = WordSearch()
    var resultsLimit = 5000
    var working : [String] = []
    var synonymWorking : [String] = []
    //Background queue only - stops the search when the results limit is hit
    private var matchesCount = 0
    //Flag for one time load of the phrases word list
    private var loadPhrases = true
    private var nabuSearch : Search? = nil
    var nabuLookUp : NabuLookUp? = nil
    private let atomicStop = AtomicBool()
    private var distinctMatchesOnly = false

    ///Call this code from a background queue
    ///Loads the specified wordlist and also the Nabu database and phrase word lists if not yet loaded
    func loadWordList(name : String) async throws {
            try await self.wordSearch.loadDictionary(resource: name)
            //Only load the phrase list once
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
    }

    ///Call this code from a background queue
    func combinedSearch(_ searchQuery : SearchQuery, callback : WordListCallback){
        working.removeAll()
        synonymWorking.removeAll()
        matchesCount = 0
        //Need to remove any duplicate matches for two-word anagrams
        distinctMatchesOnly = searchQuery.searchType == .twoWordAnagram
        if (showSynonyms) {
            if (!atomicStop.value){
                nabuSearch?.runQuery(searchQuery, callback)
                synonymWorking.append(contentsOf: working)
                working.removeAll()
            }
        }
        if (!atomicStop.value){
            wordSearch.runQuery(searchQuery, callback: callback)
        }
    }
    
    ///This code is called from the background queue
    ///For two-word anagram searches, duplicates will not be appended to the working results array
    func update(_ result: String) {
        if distinctMatchesOnly && working.contains(result){
            //already found this result so ignore it
            return
        }
        working.append(result)
        //terminate runQuery() if results limit is hit
        matchesCount = matchesCount + 1
        if matchesCount == resultsLimit {
            wordSearch.stop()
        }
    }
    
    ///This code can be called from the main queue
    func resetStop() {
        atomicStop.value = false
    }

    ///This code can be called from the main queue
    func stopSearch(){
        atomicStop.value = true
        wordSearch.stop()
    }
}
