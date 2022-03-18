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
            callback = StartsWithFilter(callback: callback, letters: filter.startingWith.lowercased())
        }
        if filter.endingWith != "" {
            callback = EndsWithFilter(callback: callback, letters: filter.endingWith.lowercased())
        }
        if filter.containing != "" {
            callback = ContainsFilter(callback: callback, letters: filter.containing.lowercased())
        }
        if filter.excluding != "" {
            callback = ExcludesFilter(callback: callback, letters: filter.excluding.lowercased())
        }
        if filter.containingWord != "" {
            callback = ContainsWordFilter(callback: callback, word: filter.containingWord.lowercased())
        }
        if filter.excludingWord != "" {
            callback = ExcludesWordFilter(callback: callback, word: filter.excludingWord.lowercased())
        }
        if filter.crossword != "" {
            callback =  RegexFilter.createCrosswordFilter(callback: callback, query: filter.crossword.lowercased())
        }
        if filter.regex != "" {
            callback =  RegexFilter(callback: callback, pattern: filter.regex.lowercased())
        }
        if filter.distinct == 1 {
            callback = DistinctFilter(callback: callback)
        }
        if filter.distinct == 2 {
            callback = NotDistinctFilter(callback: callback)
        }
        return callback
    }
    
    
}
