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
        request.testDevices = ["Simulator",
                               "bc49124e40b1cdbc39e9be4bc9fa46b7"] //iPad
        return request
    }
    enum States : Int {
        case counting, loading, noAds
    }
    
    let INTERSTITIAL_AD_UNIT_ID = "ca-app-pub-3582986480189311/6308985582"
    let MAX_COUNTS = 10
    let key = "AdsInterstitialCount"
    var interstitial : GADInterstitial!
    var state = States.counting
    
    var count : Int {
        get{
            let defaults = NSUserDefaults.standardUserDefaults()
            let c = defaults.objectForKey(key) as? Int
            if c == nil
            {
                defaults.setInteger(0, forKey: key)
                defaults.synchronize()
                return 0
            }
            return c!
        }
        set(value){
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(value, forKey: key)
            defaults.synchronize()
        }
    }
    
    func loadInterstitial()
    {
        NSLog("Loading ad")
        interstitial = GADInterstitial(adUnitID: INTERSTITIAL_AD_UNIT_ID)
        interstitial.loadRequest(Ads.createRequest())
        state = .loading
    }
    
    func noAds()
    {
        state = .noAds
        interstitial = nil
    }
    func reset()
    {
        interstitial = nil
        state = .counting
        count = 0
    }
    
    func showInterstitial(vc: UIViewController)
    {
        switch (state)
        {
        case .counting:
            count = count + 1
            if (count>=MAX_COUNTS)
            {
                loadInterstitial()
            }
        case .loading:
            if (interstitial.isReady)
            {
                interstitial.presentFromRootViewController(vc)
                state = .counting
                count=0
            }
        case .noAds: break
        }
    }
    
    
}