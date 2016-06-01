//
//  Ads.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 01/06/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import Foundation
import GoogleMobileAds

class Ads
{
    class func getBannerAdId()->String
    {
        return "ca-app-pub-3582986480189311/9351680384"
    }
    
    class func createRequest() -> GADRequest
    {
        let request = GADRequest()
        request.testDevices = ["Simulator"]
        return request
    }
    enum States : Int {
        case unititialized, loading, counting
    }
    
    let INTERSTITIAL_AD_UNIT_ID = "ca-app-pub-3582986480189311/6308985582"
    let MAX_COUNTS = 3
    var interstitial : GADInterstitial!
    var state = States.unititialized
    var count = 0
    
    func loadInterstitial()
    {
        interstitial = GADInterstitial(adUnitID: INTERSTITIAL_AD_UNIT_ID)
        interstitial.loadRequest(Ads.createRequest())
        state = .loading
    }
    
    func showInterstitial(vc: UIViewController)
    {
        switch (state)
        {
        case .unititialized:
            loadInterstitial()
        case .loading:
            count = 0
            state = .counting
        case .counting:
            count = count + 1
            if (count>=MAX_COUNTS && interstitial.isReady)
            {
                interstitial.presentFromRootViewController(vc)
                state = .unititialized
            }
        }
    }
    
    
}