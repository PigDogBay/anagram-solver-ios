//
//  FilterFactory.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

class FilterFactory : WordListCallbackAbstractFactory {
    
    let filter : Filter
    
    init(filter : Filter){
        self.filter = filter
    }
    
    func createChainedCallback(lastCallback: WordListCallback) -> WordListCallback {
        var callback = lastCallback
        
        //chain filters
        if filter.equalTo != 0 {
            callback = EqualToFilter(callback: callback, size: filter.equalTo)
        }
        if filter.lessThan != 0 {
            callback = LessThanFilter(callback: callback, size: filter.lessThan)
        }
        if filter.biggerThan != 0 {
            callback = BiggerThanFilter(callback: callback, size: filter.biggerThan)
        }
        if filter.startingWith != "" {
            callback = StartsWithFilter(callback: callback, letters: filter.startingWith)
        }
        if filter.endingWith != "" {
            callback = EndsWithFilter(callback: callback, letters: filter.endingWith)
        }
        if filter.containing != "" {
            callback = ContainsFilter(callback: callback, letters: filter.containing)
        }
        if filter.excluding != "" {
            callback = ExcludesFilter(callback: callback, letters: filter.excluding)
        }
        if filter.containingWord != "" {
            callback = ContainsWordFilter(callback: callback, word: filter.containingWord)
        }
        if filter.excludingWord != "" {
            callback = ExcludesWordFilter(callback: callback, word: filter.excludingWord)
        }
        if filter.crossword != "" {
            callback =  RegexFilter.createCrosswordFilter(callback: callback, query: filter.crossword)
        }
        if filter.regex != "" {
            callback =  RegexFilter(callback: callback, pattern: filter.regex)
        }
        if filter.isDistinctEnabled {
            callback = DistinctFilter(callback: callback)
        }
        return callback
    }
    
    
}
