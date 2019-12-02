//
//  AboutViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 29/11/2019.
//  Copyright © 2019 MPD Bailey Technology. All rights reserved.
//

import UIKit
import SwiftUtils

class AboutViewController: UIViewController, IAPDelegate {
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var relevantAdsLabel: UILabel!
    @IBOutlet weak var relevantAdsSwitch: UISwitch!
    @IBAction func buyBtnClicked(_ sender: UIButton) {
        if model.iap.canMakePayments(){
            buyButton.isEnabled=false
            model.iap.requestPurchase(IAPFactory.getProductID())
        }
    }
    @IBAction func restoreBtnClicked(_ sender: UIButton) {
        model.iap.restorePurchases()
    }
    @IBAction func privacyPolicyBtnClicked(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://pigdogbay.blogspot.co.uk/2018/05/privacy-policy.html")!, options: [:])
    }
    @IBAction func findOutMoreBtnClicked(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.google.com/policies/technologies/partner-sites/")!, options: [:])
    }
    @IBAction func relevantAdsSwitchClicked(_ sender: UISwitch) {
        model.settings.useNonPersonalizedAds = !relevantAdsSwitch.isOn
        modelToView()
    }
    
    fileprivate var model : Model!
    let observerName = "AboutVC"


    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = Model.sharedInstance
        buyButton.isEnabled=false
        modelToView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if model.settings.isProMode
        {
            //purchase already made
            self.buyButton.isEnabled=false
            self.buyButton.setTitle("Purchased",for: UIControl.State())
        }
        else if model.iap.canMakePayments()
        {
            model.iap.observable.addObserver(observerName, observer: self)
            model.iap.requestProducts()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        model.iap.observable.removeObserver(observerName)
    }
    
    //MARK:- IAPDelegate
    func productsRequest(){
        if let product = model.iap.getProduct(IAPFactory.getProductID())
        {
            DispatchQueue.main.async
            {
                self.buyButton.isEnabled=true
                self.buyButton.setTitle("Buy \(product.price)",for: UIControl.State())
            }
        }
    }
    func purchaseRequest(_ productID : String){
        if (productID == IAPFactory.getProductID()){
            DispatchQueue.main.async
            {
                self.buyButton.isEnabled=false
                self.buyButton.setTitle("Purchased",for: UIControl.State())
                //no need to show an alert, StoreKit will show a thank you
            }
        }
    }
    func restoreRequest(_ productID : String){
        if (productID == IAPFactory.getProductID()){
            DispatchQueue.main.async
            {
                self.buyButton.isEnabled=false
                self.buyButton.setTitle("Purchased",for: UIControl.State())
                //Does StoreKit show an alert here?
                self.mpdbShowAlert("Purchase Restored",msg: "Go Pro purchase has been restored, Pro features are now unlocked.")
            }
        }
        
    }
    func purchaseFailed(_ productID : String){
        DispatchQueue.main.async
        {
            self.buyButton.isEnabled=true
            //Pressing cancel (causing a fail) will not show an alert
            self.mpdbShowAlert("Purchase Failed",msg: "Sorry, unable to complete the purchase. You have not been charged.")
        }
    }
    
    private func modelToView(){
        let useNpa = model.settings.useNonPersonalizedAds
        relevantAdsLabel?.text = useNpa ? "Show me ads that are less relevant" : "Show me relevant ads"
        relevantAdsSwitch.isOn = !useNpa
    }

}
