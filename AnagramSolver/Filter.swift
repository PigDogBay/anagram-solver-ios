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
    
    var startingWith = ""
    var endingWith = ""
    var containing = ""
    var excluding = ""
    
    
    var filterCount : Int {
        get {
            var count = 0
            if biggerThan == 0 { count = count + 1}
            if lessThan == 0 { count = count + 1}
            if equalTo == 0 { count = count + 1}
            if startingWith == "" { count = count + 1}
            if endingWith == "" { count = count + 1}
            if containing == "" { count = count + 1}
            if excluding == "" { count = count + 1}
            return count
        }
    }
    
    func reset() {
        biggerThan = 0
        lessThan = 0
        equalTo = 0
        startingWith = ""
        endingWith = ""
        containing = ""
        excluding = ""
    }
    
    
}
