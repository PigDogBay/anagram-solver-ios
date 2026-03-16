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

@Observable
class AboutViewModel {
    
    var result: Result<MFMailComposeResult, Error>? = nil
    var isMailVCPresented = false
    var showNoEmailAlert = false

    @ObservationIgnored private let ads : Ads
    let observerName = "AboutVM"
    
    init(ads: Ads) {
        self.ads = ads
    }
    
    var canShowPrivacyForm : Bool {
        ads.isPrivacyOptionsRequired
    }

    func showAdPrivacyForm(){
        ads.showPrivacyForm()
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

    func feedback(){
        if MFMailComposeViewController.canSendMail() {
            isMailVCPresented = true
        } else if let emailUrl = mpdbCreateEmailUrl(to: Strings.emailAddress, subject: Strings.feedbackSubject, body: "")  {
            UIApplication.shared.open(emailUrl)
        } else {
            showNoEmailAlert = true
        }
    }

}
