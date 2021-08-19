//
//  Coordinator.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/02/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils
import Combine

///Deals with interactions between views and holds shared observed variables
class Coordinator : ObservableObject {

    var rootVC : RootViewController?
    @Published var showCards = true
    @Published var selection : Int? = nil
    
    static let SHOW_SETTINGS = 1

    func showHelpExample(example : String){
        rootVC?.showMe(query: example)
    }
    
    func sendFeedback(){
        rootVC?.sendFeedback()
    }
    
    func autoTest(){
        AutoTest.start(model: Model.sharedInstance, rootVC: rootVC!)
    }
    
    func showSettings(){
        selection = Coordinator.SHOW_SETTINGS
    }

    func updateSettings(){
        rootVC?.appEnterForgeround()
    }
}

