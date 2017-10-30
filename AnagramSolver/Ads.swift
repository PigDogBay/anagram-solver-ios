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

    static var bannerView : GADBannerView?

    static func createRequest() -> GADRequest
    {
        let request = GADRequest()
        request.testDevices = [
            "Simulator",
            "4ccb6d94e22bce9a7212f16cc927c429",//iPad
            "cc0b7644c90c4ab95e0150938951def3" //iPhone
        ]
        return request
    }
    
    
    static func createBannerView(vc : UIViewController){
        if nil == bannerView {
            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            bannerView!.adUnitID = Ads.bannerAdId
            bannerView!.rootViewController = vc
            bannerView!.load(Ads.createRequest())
        }
    }
    
    static func addAdView(container : UIView){
        if let banner = bannerView
        {
            container.addSubview(banner)
            banner.alpha = 0.0
            UIView.animate(withDuration: 1){
                banner.alpha = 1.0
            }
        }
    }

}
