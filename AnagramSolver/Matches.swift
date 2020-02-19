//
//  Matches.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 31/10/2019.
//  Copyright © 2019 MPD Bailey Technology. All rights reserved.
//

import Foundation

protocol MatchFoundObserver : class
{
    func matchFound()
}

class Matches {
    fileprivate let TABLE_MAX_COUNT_TO_RELOAD = 100
    private var matches : [String] = []
    private let queue  = DispatchQueue(label: "com.pigdogbay.anagramsolver.matches.queue")
    private weak var matchFoundObserver : MatchFoundObserver?

    subscript(index : Int) -> String{
        get {
            return queue.sync {
                return matches[index]
            }
        }
        set {
            queue.sync{
                matches[index] = newValue
            }
        }
    }
    
    var count : Int {
        return queue.sync{
            return matches.count
        }
    }
    func removeAll(){
        queue.sync{
            matches.removeAll(keepingCapacity: true)
        }
    }
    func append(match : String){
        queue.sync{
            matches.append(match)
        }
    }
    func flatten()->String {
        return queue.sync{
            return matches.reduce(""){result, next in result+next+"\n"}
        }
    }

    func setMatchesObserver(observer : MatchFoundObserver){
        queue.sync{
            self.matchFoundObserver = observer
        }
    }
    func removeMatchObserver(){
        queue.sync {
            self.matchFoundObserver = nil
        }
    }
    func matchFound(match : String){
        queue.sync{
            matches.append(match)
            if let obs = matchFoundObserver, matches.count<self.TABLE_MAX_COUNT_TO_RELOAD
            {
                obs.matchFound()
            }
        }
    }
}
