//
//  GoProViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/06/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import UIKit
import SwiftUtils

class GoProViewController: UIViewController, IAPDelegate {
    @IBOutlet weak var buyButton: UIButton!

    @IBAction func buyBtnClicked(_ sender: UIButton) {
        if model.iap.canMakePayments(){
            buyButton.isEnabled=false
            model.iap.requestPurchase(IAPFactory.getProductID())
        }
    }
    @IBAction func restoreBtnClicked(_ sender: UIButton) {
        model.iap.restorePurchases()
    }

    fileprivate var model : Model!
    let observerName = "GoProVC"


    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = Model.sharedInstance
        buyButton.isEnabled=false
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
    
}
