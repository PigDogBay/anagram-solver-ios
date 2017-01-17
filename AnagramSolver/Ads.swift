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
        request.testDevices = [
            "Simulator",
            "4ccb6d94e22bce9a7212f16cc927c429",//iPad
            "cc0b7644c90c4ab95e0150938951def3" //iPhone
        ]
        return request
    }
    enum States : Int {
        case counting, loading, noAds
    }
    
    fileprivate let INTERSTITIAL_AD_UNIT_ID = "ca-app-pub-3582986480189311/6308985582"
    fileprivate let MAX_COUNTS = 20
    fileprivate let key = "AdsInterstitialCount"
    fileprivate var interstitial : GADInterstitial!
    fileprivate var state = States.counting
    
    fileprivate var count : Int {
        get{
            let defaults = UserDefaults.standard
            let c = defaults.object(forKey: key) as? Int
            if c == nil
            {
                defaults.set(0, forKey: key)
                defaults.synchronize()
                return 0
            }
            return c!
        }
        set(value){
            let defaults = UserDefaults.standard
            defaults.set(value, forKey: key)
            defaults.synchronize()
        }
    }
    
    fileprivate func loadInterstitial()
    {
        NSLog("Loading ad")
        interstitial = GADInterstitial(adUnitID: INTERSTITIAL_AD_UNIT_ID)
        interstitial.load(Ads.createRequest())
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
    
    func showInterstitial(_ vc: UIViewController)
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
                interstitial.present(fromRootViewController: vc)
                state = .counting
                count=0
            }
        case .noAds: break
        }
    }
    
    
}
