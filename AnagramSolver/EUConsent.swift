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
 */
class EUConsent {
    let viewController : UIViewController
    var euConsentForm : PACConsentForm?
    
    init(viewController : UIViewController){
        self.viewController = viewController
    }

func checkEUConsent(){
//TESTING - reset here
//    PACConsentInformation.sharedInstance.reset()
    print("Checking EU Consent")
    PACConsentInformation.sharedInstance.requestConsentInfoUpdate(
    forPublisherIdentifiers: ["pub-3582986480189311"])
    {(_ error: Error?) -> Void in
      if let error = error {
        // Consent info update failed.
        print("EU Consent update failed \(error)")
      } else {
        // Consent info update succeeded. The shared PACConsentInformation
        // instance has been updated.
        let status = PACConsentInformation.sharedInstance.consentStatus
        switch status {
        case .unknown:
            print("Consent status is unknown")
            if PACConsentInformation.sharedInstance.isRequestLocationInEEAOrUnknown {
                print("User is in the EU")
                self.showEUConsentForm()
            } else {
                print("User is not in the EU")
            }
        case .nonPersonalized:
            print("Show non personalized ads")
        case .personalized:
            print("Show personalized ads")
        @unknown default:
            print("Unexpected status value")
        }
      }
    }
}
func showEUConsentForm(){
    let privacyUrl = URL(string: "https://pigdogbay.blogspot.co.uk/2018/05/privacy-policy.html")!
    euConsentForm = PACConsentForm(applicationPrivacyPolicyURL: privacyUrl)
    euConsentForm?.shouldOfferPersonalizedAds = true
    euConsentForm?.shouldOfferNonPersonalizedAds = true
    euConsentForm?.shouldOfferAdFree = true
    euConsentForm?.load {(_ error: Error?) -> Void in
      print("Load complete.")
      if let error = error {
        // Handle error.
        print("Error loading form: \(error.localizedDescription)")
      } else {
        // Load successful.
        self.presentEUConsent()
      }
    }
}

func presentEUConsent(){
    euConsentForm?.present(from: viewController) { (error, userPrefersAdFree) in
        if let error = error {
            print("Consent Form Response: Error \(error)")
            // Handle error.
        } else if userPrefersAdFree {
            print("Consent Form Response: Use prefers ad free")
            // User prefers to use a paid version of the app.
        } else {
            // Check the user's consent choice.
            let status = PACConsentInformation.sharedInstance.consentStatus
            switch status {
            case .unknown:
                print("Consent Form Response chose: unknown")
            case .nonPersonalized:
                print("Consent Form Response chose: non-personalized")
            case .personalized:
                print("Consent Form Response chose: personalized")
            @unknown default:
                print("Consent Form Response chose: invalid")
            }
        }
        self.euConsentForm = nil
    }
    
}
}
