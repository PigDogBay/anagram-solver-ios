//
//  AboutViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 09/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import UIKit
import Combine
import MessageUI
import SwiftUtils

class AboutViewModel : ObservableObject, IAPDelegate {
    @Published var showMeRelevantAds = true
    @Published var buyButtonEnabled = false
    @Published var buyButtonText = "BUY"
    @Published var showAlertRestored = false
    @Published var showAlertFailed = false
    let model : Model
    let observerName = "AboutVM"

    init(){
        model = Model.sharedInstance
    }
    
    func onAppear(){
        showMeRelevantAds = !model.settings.useNonPersonalizedAds
        if model.settings.isProMode
        {
            //purchase already made
            buyButtonEnabled=false
            buyButtonText = "Purchased"
        }
        else if model.iap.canMakePayments()
        {
            model.iap.observable.addObserver(observerName, observer: self)
            model.iap.requestProducts()
        }
    }
    
    func onDisappear(){
        model.settings.useNonPersonalizedAds = !showMeRelevantAds
        model.iap.observable.removeObserver(observerName)
    }

    func showPrivacyPolicy(){
        UIApplication.shared.open(URL(string: Strings.privacyURL)!, options: [:])
    }
    
    func showGooglePrivacyPolicy(){
        UIApplication.shared.open(URL(string: "https://www.google.com/policies/technologies/partner-sites/")!, options: [:])
    }
    
    func rate(){
        UIApplication.shared.open(URL(string: Strings.itunesAppURL)!, options: [:])
    }
    
    func buy(){
        if model.iap.canMakePayments(){
            buyButtonEnabled=false
            model.iap.requestPurchase(IAPFactory.getProductID())
        }
    }

    func restorePurchase(){
        model.iap.restorePurchases()
    }
    
    //MARK:- IAPDelegate
    func productsRequest(){
        if let product = model.iap.getProduct(IAPFactory.getProductID())
        {
            DispatchQueue.main.async
            {
                self.buyButtonEnabled=true
                self.buyButtonText = "Buy \(product.price)"
            }
        }
    }

    func purchaseRequest(_ productID : String){
        if (productID == IAPFactory.getProductID()){
            DispatchQueue.main.async
            {
                self.buyButtonEnabled=false
                self.buyButtonText = "Purchased"
                //no need to show an alert, StoreKit will show a thank you
            }
        }
    }

    func restoreRequest(_ productID : String){
        if (productID == IAPFactory.getProductID()){
            DispatchQueue.main.async
            {
                self.buyButtonEnabled=false
                self.buyButtonText = "Purchased"
                //Does StoreKit show an alert here?
                self.showAlertRestored = true
            }
        }
        
    }

    func purchaseFailed(_ productID : String){
        DispatchQueue.main.async
        {
            self.buyButtonEnabled=true
            //Pressing cancel (causing a fail) will not show an alert
            self.showAlertFailed=true
        }
    }
}
