//
//  Filters.swift
//
//  Created by Mark Bailey on 16/06/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUtils
import SwiftData

@Model class Filters {
    @Transient var isActive : Bool = false

    var contains : String
    var excludes : String
    var containsWord : String
    var excludesWord : String
    var prefix : String
    var suffix : String
    var isStartingWithNotEnabled  : Bool
    var isEndingWithNotEnabled  : Bool
    var pattern : String
    var regExp : String
    var distinctSelection : Int
    var lessThan : Int
    var moreThan : Int
    var equalTo : Int
    
    static let DISTINCT = 1
    static let NOT_DISTINCT = 2
    
    var filterCount : Int {
        var count = 0
        if moreThan != 0 { count = count + 1}
        if lessThan != 0 { count = count + 1}
        if equalTo != 0 { count = count + 1}
        if distinctSelection != 0 { count = count + 1}
        if prefix != "" { count = count + 1}
        if suffix != "" { count = count + 1}
        if contains != "" { count = count + 1}
        if excludes != "" { count = count + 1}
        if containsWord != "" { count = count + 1}
        if excludesWord != "" { count = count + 1}
        if pattern != "" { count = count + 1}
        if regExp != "" { count = count + 1}
        return count
    }
    
    init(contains: String = "", excludes: String = "", containsWord: String = "", excludesWord: String = "", prefix: String = "", suffix: String = "", isStartingWithNotEnabled: Bool = false, isEndingWithNotEnabled: Bool = false, pattern: String = "", regExp: String = "", distinctSelection: Int = 0, lessThan: Int = 0, moreThan: Int = 0, equalTo: Int = 0) {
        self.contains = contains
        self.excludes = excludes
        self.containsWord = containsWord
        self.excludesWord = excludesWord
        self.prefix = prefix
        self.suffix = suffix
        self.isStartingWithNotEnabled = isStartingWithNotEnabled
        self.isEndingWithNotEnabled = isEndingWithNotEnabled
        self.pattern = pattern
        self.regExp = regExp
        self.distinctSelection = distinctSelection
        self.lessThan = lessThan
        self.moreThan = moreThan
        self.equalTo = equalTo
    }
    
    
    /// The title indicates the number of filters set
    var title : String {
        let count = filterCount
        return count == 0 ? "Filters" : "Filters (\(count))"
    }
    
    func reset() {
        moreThan = 0
        lessThan = 0
        equalTo = 0
        distinctSelection = 0
        prefix = ""
        suffix = ""
        isStartingWithNotEnabled = false
        isEndingWithNotEnabled = false
        contains = ""
        excludes = ""
        containsWord = ""
        excludesWord = ""
        pattern = ""
        regExp = ""
    }
    
    func activeFiltersDescriptions() -> [String] {
        var list = [String]()
        
        if contains != "" {list.append("Contains letters \(contains)")}
        if excludes != "" {list.append("Excludes letters \(excludes)")}
        if distinctSelection == Filters.DISTINCT {
            list.append("All letters are different")
        } else if distinctSelection == Filters.NOT_DISTINCT {
            list.append("Some letters are the same")
        }

        if containsWord != "" {list.append("Contains word \(containsWord)")}
        if excludesWord != "" {list.append("Excludes word \(excludesWord)")}

        let prefixNot = isStartingWithNotEnabled ? "Not s" : "S"
        if prefix != "" {list.append("\(prefixNot)tarting with \(prefix)")}
        let suffixNot = isEndingWithNotEnabled ? "Not e" : "E"
        if suffix != "" {list.append("\(suffixNot)nding with \(suffix)")}

        if pattern != "" {list.append("Pattern \(pattern)")}
        if regExp != "" {list.append("Reg Exp \(regExp)")}

        if moreThan != 0 {list.append("More than \(moreThan) letters")}
        if lessThan != 0 {list.append("Less than \(lessThan) letters")}
        if equalTo != 0 {list.append("Equal to \(equalTo) letters")}
        return list
    }

    func createChainedCallback(lastCallback: WordListCallback) -> WordListCallback {
        var callback = lastCallback
        
        //chain filters
        if self.equalTo != 0 {
            callback = EqualToFilter(callback: callback, size: self.equalTo)
        }
        if self.lessThan != 0 {
            callback = LessThanFilter(callback: callback, size: self.lessThan)
        }
        if self.moreThan != 0 {
            callback = BiggerThanFilter(callback: callback, size: self.moreThan)
        }
        if self.prefix != "" {
            callback = StartsWithFilter(callback: callback, letters: self.prefix.lowercased(),
                                        isNot: self.isStartingWithNotEnabled)
        }
        if self.suffix != "" {
            callback = EndsWithFilter(callback: callback, letters: self.suffix.lowercased(),
                                      isNot: self.isEndingWithNotEnabled)
        }
        if self.contains != "" {
            callback = ContainsFilter(callback: callback, letters: self.contains.lowercased())
        }
        if self.excludes != "" {
            callback = ExcludesFilter(callback: callback, letters: self.excludes.lowercased())
        }
        if self.containsWord != "" {
            callback = ContainsWordFilter(callback: callback, word: self.containsWord.lowercased())
        }
        if self.excludesWord != "" {
            callback = ExcludesWordFilter(callback: callback, word: self.excludesWord.lowercased())
        }
        if self.pattern != "" {
            callback =  RegexFilter.createCrosswordFilter(callback: callback, query: self.pattern.lowercased())
        }
        if self.regExp != "" {
            callback =  RegexFilter(callback: callback, pattern: self.regExp.lowercased())
        }
        if self.distinctSelection == Filters.DISTINCT {
            callback = DistinctFilter(callback: callback)
        }
        if self.distinctSelection == Filters.NOT_DISTINCT {
            callback = NotDistinctFilter(callback: callback)
        }
        return callback
    }
    
}
