//
//  DefinitionViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 11/04/2024.
//  Copyright © 2024 MPD Bailey Technology. All rights reserved.
//

import UIKit
import SwiftUI
import SwiftUtils
import GoogleMobileAds
import UserMessagingPlatform

class DefinitionViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!

    ///See book, SwiftUI Essentials 34.7 for embedding UIHostingController
    @IBSegueAction func embedSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: DefinitionView(dictionary))
    }
    var word : String!
    var dictionary : WordDictionary!
    fileprivate var model : Model!

    private var screenWidth : CGFloat {
        return view.frame.inset(by: view.safeAreaInsets).size.width
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = word
        
        self.model = Model.sharedInstance

        if model.settings.isProMode
        {
            bannerHeightConstraint.constant = 0
        }
        else
        {
            bannerView.adUnitID = Ads.definitionAdId
            bannerView.rootViewController = self
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        coordinator.animate(alongsideTransition: { _ in
          self.loadAd()
        })
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // Note loadBannerAd is called in viewDidAppear as this is the first time that
        // the safe area is known. If safe area is not a concern (e.g., your app is
        // locked in portrait mode), the banner can be loaded in viewWillAppear.
        loadAd()
    }


    private func loadAd(){
        if !model.settings.isProMode && UMPConsentInformation.sharedInstance.canRequestAds
        {
            //Set up bannerView height for the device
            //Another method is to set the bannerHeightConstraint relation to be greater than or equal to 0
            //but IB complains about ambiguous constraints
            let adSize = Ads.createAdsize(screenWidth: screenWidth)
            bannerHeightConstraint.constant = adSize.size.height
            bannerView.adSize = adSize
            bannerView.load(Ads.createRequest(useNpa: model.settings.useNonPersonalizedAds))
        }
    }


}
