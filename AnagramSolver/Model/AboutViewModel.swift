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
    private let model : Model
    let observerName = "AboutVM"
    
    var canShowPrivacyForm : Bool {
        model.ads.isPrivacyOptionsRequired
    }
    
    init(){
        model = Model.sharedInstance
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
}
