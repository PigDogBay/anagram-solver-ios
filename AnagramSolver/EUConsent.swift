//
//  EUConsent.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 25/06/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Foundation
import PersonalizedAdConsent
/*
Based on
https://developers.google.com/admob/ios/eu-consent
By default personalized ads are shown, this code will do the following
 -Check consent status
 -If consent is unknown and the user is in the EU then show the consent form
 -The consent form will take the user to the about screen or set useNonPersonalizedAds to true or false
 */
class EUConsent {
    let viewController : UIViewController
    var euConsentForm : PACConsentForm?
    
    init(viewController : UIViewController){
        self.viewController = viewController
    }
    
    func reset() {
        PACConsentInformation.sharedInstance.reset()
    }

    func checkEUConsent(){
        PACConsentInformation.sharedInstance.requestConsentInfoUpdate(
        forPublisherIdentifiers: ["pub-3582986480189311"])
        {(_ error: Error?) -> Void in
            if error == nil &&
                PACConsentInformation.sharedInstance.consentStatus == .unknown  &&
                PACConsentInformation.sharedInstance.isRequestLocationInEEAOrUnknown {
                self.showEUConsentForm()
            }
        }
    }
    
    func showEUConsentForm(){
        let privacyUrl = URL(string: Model.privacyURL)!
        euConsentForm = PACConsentForm(applicationPrivacyPolicyURL: privacyUrl)
        euConsentForm?.shouldOfferPersonalizedAds = true
        euConsentForm?.shouldOfferNonPersonalizedAds = true
        euConsentForm?.shouldOfferAdFree = true
        euConsentForm?.load {(_ error: Error?) -> Void in
            if error == nil {
                self.presentEUConsent()
            }
        }
    }

    func presentEUConsent(){
        euConsentForm?.present(from: viewController) { (error, userPrefersAdFree) in
            self.euConsentForm = nil
            if error == nil {
                if userPrefersAdFree {
                    self.viewController.performSegue(withIdentifier: "aboutSegue", sender: self.viewController)
                } else if PACConsentInformation.sharedInstance.consentStatus == .personalized {
                    Settings().useNonPersonalizedAds = false
                } else {
                    Settings().useNonPersonalizedAds = true
                }
            }
        }
    }
}
