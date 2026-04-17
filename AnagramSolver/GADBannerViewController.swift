//
//  GADBannerViewController.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 22/06/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleMobileAds

/*
 Based on https://stackoverflow.com/questions/57641603/google-admob-integration-in-swiftui
 The hard part is knowing the actual size of the adaptive banner before its displayed so that
 SwiftUI layout code can set the frame width and height
 
*/
struct GADBannerViewController: UIViewControllerRepresentable {
    @Binding var isAdLoaded: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let bannerSize = GADBannerViewController.getAdBannerSize()
        let viewController = UIViewController()
        let banner = BannerView(adSize: bannerSize)
        banner.adSize = bannerSize
        banner.adUnitID = Ads.bannerAdId
        banner.rootViewController = viewController
        banner.delegate = context.coordinator
        viewController.view.addSubview(banner)
        viewController.view.frame = CGRect(origin: .zero, size: bannerSize.size)
        banner.load(Ads.createRequest())
        return viewController
    }

    //This gets called 3x immediately after makeUIVC
    //Since the ad will only be displayed on the results screen,
    //there is no point in updating the ad here
    func updateUIViewController(_ uiViewController: UIViewController, context: Context){
    }
    
    // Coordinator and other methods remain unchanged
    class Coordinator: NSObject, BannerViewDelegate {
        var parent: GADBannerViewController
        
        init(_ parent: GADBannerViewController) {
            self.parent = parent
        }
        
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            parent.isAdLoaded = true
        }
        
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("Failed to load ad: \(error.localizedDescription)")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /*
        An adaptive banner's size is based on the screen width, this calculates the safe area screen width
        and then uses this to calculate the banner size.
        This function is also called by the SwiftUI code.
     */
    static func getAdBannerSize() -> AdSize {
        if let scene = UIApplication.shared.connectedScenes.first(where:{$0 is UIWindowScene}) as? UIWindowScene {
            if let rootView = scene.windows.first?.rootViewController?.view {
                let frame = rootView.frame.inset(by: rootView.safeAreaInsets)
                if (UIDevice.current.orientation.isLandscape){
                    return landscapeAnchoredAdaptiveBanner(width: frame.width)
                } else {
                    return portraitAnchoredAdaptiveBanner(width: frame.width)
                }
//New banner is twice the height, users dunna larke eet
//                return largeAnchoredAdaptiveBanner(width: frame.width)
            }
        }
        //No root VC, use 320x50 ad banner
        return AdSizeBanner
    }
}
