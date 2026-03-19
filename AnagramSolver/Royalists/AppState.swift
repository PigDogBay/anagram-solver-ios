//
//  AppState.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 01/11/2019.
//  Copyright © 2019 MPD Bailey Technology. All rights reserved.
//

import Foundation

protocol RAppStateChangeObserver : AnyObject
{
    func appStateChanged(_ newState : AppStates)
}

class RAppStateObservable {
    private var observers = [RAppStateChangeObserver]()
    private let queue  = DispatchQueue(label: "com.pigdogbay.anagramsolver.appstateobservable.queue")
    private var state = AppStates.uninitialized

    var appState : AppStates {
        get {
            return queue.sync {
                return state
            }
        }
        set {
            queue.sync {
                if (state != newValue){
                    state = newValue
                    observers.forEach{$0.appStateChanged(newValue)}
                }
            }
        }
    }
    
    func addObserver(observer : RAppStateChangeObserver){
        queue.sync {
            if !observers.contains(where: {$0 === observer}){
                observers.append(observer)
            }
        }
    }

    func removeObserver(observer : RAppStateChangeObserver){
        queue.sync {
            if let index = observers.firstIndex(where: {$0 === observer}){
                observers.remove(at: index)
            }
        }
    }
    
    func isReadyFinished() -> Bool {
        return queue.sync {
            if self.state == .finished
            {
                state = .ready
            }
            return self.state == .ready
        }
    }
}
