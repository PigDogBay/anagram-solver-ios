//
//  Ads.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 01/06/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport
import SwiftUtils

class Ads
{
    static let bannerAdId = "ca-app-pub-3582986480189311/9351680384"
    var isAdsSetupFinished = false

    func setUp()
    {
        if !isAdsSetupFinished {
            self.isAdsSetupFinished = true
            requestIDFA()
        }
    }
    /**
     For testing: delete the app to show dialog
     Dialog appears only once, on queue, com.apple.root.default-qos
     Otherwise .authorized or .denied is return on main-thread
     */
    private func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                self.initializeAds()
            })
        } else {
            // Fallback on earlier versions
            self.initializeAds()
        }
    }
    
    private func initializeAds(){
        let requestConfiguration = GADMobileAds.sharedInstance().requestConfiguration
        //app will be rated 4+, so can only show general ads
        requestConfiguration.maxAdContentRating = .general
        //Admob SDK guide recommends removing this code for release builds
        #if DEBUG
        requestConfiguration.testDeviceIdentifiers = [
            (kGADSimulatorID),
            "dd7094a5b568e8b751d05661330cceae", //iPhone
            "6af877373ece0e06c9fc7007cc41edf2",//iPad
            "a4b042150b6cace14cc182d6bf254d09"//iPod Touch
           ]
        #endif
        GADMobileAds.sharedInstance().start(completionHandler: nil)
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
