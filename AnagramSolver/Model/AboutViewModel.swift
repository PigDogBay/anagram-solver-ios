//
//  AboutViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 09/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import UIKit
import Combine
import MessageUI
import SwiftUtils

class AboutViewModel : ObservableObject {
    @Published var buyButtonEnabled = false
    @Published var buyButtonText = "BUY"
    @Published var showAlertRestored = false
    @Published var showAlertFailed = false
    let model : Model
    let observerName = "AboutVM"
    
    var canShowPrivacyForm : Bool {
        model.ads.isPrivacyOptionsRequired
    }
    
    init(){
        model = Model.sharedInstance
    }

    func onAppear(){
        if model.settings.isProMode
        {
            //purchase already made
            buyButtonEnabled=false
            buyButtonText = "Purchased"
        }
    }
    
    func onDisappear(){
    }

    func showAdPrivacyForm(){
        model.ads.showPrivacyForm()
    }
    
    func showPrivacyPolicy(){
        UIApplication.shared.open(URL(string: Strings.privacyURL)!, options: [:])
    }
    
    func showGooglePrivacyPolicy(){
        UIApplication.shared.open(URL(string: "https://www.google.com/policies/technologies/partner-sites/")!, options: [:])
    }
    
    class func rate(){
        UIApplication.shared.open(URL(string: Strings.itunesAppURL)!, options: [:])
    }
    
    func buy(){
        model.storeVM.buy()
    }

    func restorePurchase(){
        model.storeVM.restorePurchase()
    }
}
