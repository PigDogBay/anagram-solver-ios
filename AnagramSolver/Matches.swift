//
//  Matches.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 31/10/2019.
//  Copyright © 2019 MPD Bailey Technology. All rights reserved.
//

import Foundation

class Matches {
    private var matches : [String] = []
    private var grouped : [[String]]?

    var count : Int {
        return matches.count
    }
    
    var sections : Int {
       return grouped?.count ?? 0
    }
    
    func getNumberOfRows(section : Int) -> Int {
        return grouped?[section].count ?? 0
    }
    
    func getMatch(section : Int, row : Int) -> String?{
        return grouped?[section][row]
    }
    
    func getNumberOfLetters(section : Int) -> Int{
        return grouped?[section][0].length ?? 0
    }
    
    func removeAll(){
        grouped?.removeAll()
        grouped = nil
        matches.removeAll(keepingCapacity: true)
    }

    func append(match : String){
        matches.append(match)
    }

    func flatten()->String {
        return matches.reduce(""){result, next in result+next+"\n"}
    }

    func matchFound(match : String){
        matches.append(match)
    }
    
    func groupBySize() {
        self.grouped = Dictionary(grouping: matches, by: {$0.length})
            .sorted (by: {$0.0 > $1.0})
            .map{$0.value}
    }
}
