//
//  Filter.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/11/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import Foundation

class Filter {
    
    var biggerThan = 0
    var lessThan = 0
    var equalTo = 0
    var distinct = 0

    var startingWith = ""
    var endingWith = ""
    var containing = ""
    var excluding = ""
    var containingWord = ""
    var excludingWord = ""
    var crossword = ""
    var regex = ""
    
    //This is not a filter, the user can edit the main query from the filter screen
    var query = ""
    
    private(set) var filterCount : Int = 0
    
    func updateFilterCount() {
        var count = 0
        if biggerThan != 0 { count = count + 1}
        if lessThan != 0 { count = count + 1}
        if equalTo != 0 { count = count + 1}
        if distinct != 0 { count = count + 1}
        if startingWith != "" { count = count + 1}
        if endingWith != "" { count = count + 1}
        if containing != "" { count = count + 1}
        if excluding != "" { count = count + 1}
        if containingWord != "" { count = count + 1}
        if excludingWord != "" { count = count + 1}
        if crossword != "" { count = count + 1}
        if regex != "" { count = count + 1}
        self.filterCount = count
    }
    
    func reset() {
        filterCount = 0
        biggerThan = 0
        lessThan = 0
        equalTo = 0
        distinct = 0
        startingWith = ""
        endingWith = ""
        containing = ""
        excluding = ""
        containingWord = ""
        excludingWord = ""
        crossword = ""
        regex = ""
    }
}
