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

    //Singleton, occasionally get null pointer crashes if try to use it as Environment variable
    static let sharedInstance = Coordinator()
    private init(){}

    var rootVC : RootViewController?
    @Published var showCards = true
    @Published var selection : Int? = nil
    //Using a @state variable to toggle the tell sheet does not work
    @Published var showTell = false

    var tip : Tip = anagramTip
    
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
    
    func show(_ tip : Tip){
        self.tip = tip
        selection = SHOW_HELP
    }

    /// Call when the user exits the Settings screen and apply any setting changes
    func updateSettings(){
        Model.sharedInstance.checkForSettingsChange()
        showCards = Model.sharedInstance.settings.showCardTips
        rootVC?.updateSettings()
    }

    func webLookUp(word : String) {
        let defModel = DefaultDefintion(word: word)
        if let url = defModel.lookupUrl(){
            showWebPage(address: url)
        }
    }
    
    func showWebPage(address : String) {
        if let url = URL(string: address) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

