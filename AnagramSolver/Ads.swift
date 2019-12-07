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
        requestConfiguration.testDeviceIdentifiers = [
            (kGADSimulatorID as! String),
            "1d0dd7e23d31eae8a3e9ad16a8c9b3b4",//iPad
            "a4b042150b6cace14cc182d6bf254d09",//iPod Touch
            "cc0b7644c90c4ab95e0150938951def3" //iPhone
           ]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    static func createRequest(useNpa : Bool) -> GADRequest{
        let request = GADRequest()
        if useNpa {
            print("Showing NPA")
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
        }
        return request
    }
}
