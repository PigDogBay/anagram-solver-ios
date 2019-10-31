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
    private let queue  = DispatchQueue(label: "com.pigdogbay.anagramsolver.matches.queue")
    
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
}
