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
}
