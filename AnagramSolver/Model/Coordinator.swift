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
    
    let SHOW_ABOUT = 1
    let SHOW_DEFINITION_HELP = 2
    let SHOW_FILTER_HELP = 3
    let SHOW_HELP = 4
    let SHOW_SETTINGS = 5
    let SHOW_SETTINGS_HELP = 6

    func showHelpExample(example : String){
        rootVC?.showMe(query: example)
    }
    
    func sendFeedback(){
        rootVC?.sendFeedback()
    }
    
    func autoTest(){
        AutoTest.start(model: Model.sharedInstance, rootVC: rootVC!)
    }
    
    func show(_ viewId : Int){
        selection = viewId
    }

    func updateSettings(){
        rootVC?.appEnterForgeround()
    }
}

