//
//  Ads.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 01/06/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds

struct Ads
{
    static let bannerAdId = "ca-app-pub-3582986480189311/9351680384"

    static func setup(){
        let requestConfiguration = GADMobileAds.sharedInstance().requestConfiguration
        //app is rated 17+, so may as well allow mature ads
        requestConfiguration.maxAdContentRating = .matureAudience
        //Admob SDK guide recommends removing this code for release builds
        #if DEBUG
        requestConfiguration.testDeviceIdentifiers = [
            (kGADSimulatorID as! String),
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
