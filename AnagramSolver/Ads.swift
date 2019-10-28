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

    static func createRequest() -> GADRequest
    {
        let request = GADRequest()
        request.testDevices = [
            "Simulator",
            "1d0dd7e23d31eae8a3e9ad16a8c9b3b4",//iPad
            "cc0b7644c90c4ab95e0150938951def3" //iPhone
        ]
        return request
    }
}
