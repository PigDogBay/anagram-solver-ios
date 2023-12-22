//
//  Ads.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 01/06/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftUtils
import UserMessagingPlatform

class Ads
{
    static let bannerAdId = "ca-app-pub-3582986480189311/9351680384"
    private var isAdsSetupFinished = false
    // Use a boolean to initialize the Google Mobile Ads SDK and load ads once.
    private var isMobileAdsStartCalled = false

    func setUp(viewControler : UIViewController)
    {
        if !isAdsSetupFinished {
            self.isAdsSetupFinished = true
            umpRequest(viewControler)
        }
    }
    
    private func setUpDebug(_ parameters : UMPRequestParameters){
        UMPConsentInformation.sharedInstance.reset()
        let debugSettings = UMPDebugSettings()
        debugSettings.geography = .notEEA
        debugSettings.testDeviceIdentifiers = ["A9AB339F-440F-4116-9BA1-BF7EC15CB959"]
        parameters.debugSettings = debugSettings
    }
    
    ///See https://developers.google.com/admob/ios/privacy
    ///Also make sure GDPR and IDFA explainer are set up on Admob-> Privacy and Messaging
    private func umpRequest(_ viewControler : UIViewController){
        let parameters = UMPRequestParameters()
        parameters.tagForUnderAgeOfConsent = false
//        setUpDebug(parameters)
        
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters){
            [weak self] requestConsentError in
            guard let self else {return}
            if let consentError = requestConsentError {
                return print("UMP Info Update Error: \(consentError.localizedDescription)")
            }
            
            UMPConsentForm.loadAndPresentIfRequired(from: viewControler){
                [weak self] loadAndPresentError in
                guard let self else {return}
                if let consentError = loadAndPresentError {
                    return print("UMP Load Present Error: \(consentError.localizedDescription)")
                }
                if UMPConsentInformation.sharedInstance.canRequestAds {
                    self.initializeAds()
                }
            }
        }
        //Try load an ad immediately
        if UMPConsentInformation.sharedInstance.canRequestAds {
            self.initializeAds()
        }
    }
    
    private func initializeAds(){
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else {return}
            self.isMobileAdsStartCalled = true
            let requestConfiguration = GADMobileAds.sharedInstance().requestConfiguration
            //app will be rated 4+, so can only show general ads
            requestConfiguration.maxAdContentRating = .general
            //Admob SDK guide recommends removing this code for release builds
#if DEBUG
            requestConfiguration.testDeviceIdentifiers = [
                "dd7094a5b568e8b751d05661330cceae", //iPhone
                "29E32845-E763-4E6B-BCE6-9B9F8B642F46",//iPad
                "a4b042150b6cace14cc182d6bf254d09"//iPod Touch
               ]
#endif
            GADMobileAds.sharedInstance().start()
        }
    }
    
    static func createRequest(useNpa : Bool) -> GADRequest{
        let request = GADRequest()
        if useNpa {
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
        }
        return request
    }
    
    static func createAdsize(screenWidth : CGFloat) -> GADAdSize {
        //GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth does not work for landscape
        if (UIDevice.current.orientation.isLandscape){
            return GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth(screenWidth)
        } else {
            return GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(screenWidth)
        }
    }
}
