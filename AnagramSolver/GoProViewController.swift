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

    @IBAction func buyBtnClicked(sender: UIButton) {
        if model.iap.canMakePayments(){
            buyButton.enabled=false
            model.iap.requestPurchase(IAPFactory.getGoProId())
        }
    }
    @IBAction func restoreBtnClicked(sender: UIButton) {
        model.iap.restorePurchase(IAPFactory.getGoProId())
    }

    private var model : Model!
    let observerName = "GoProVC"


    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = Model.sharedInstance
        buyButton.enabled=false
    }
    override func viewDidAppear(animated: Bool) {
        if model.isProMode
        {
            //purchase already made
            self.buyButton.enabled=false
            self.buyButton.setTitle("Purchased",forState: .Normal)
        }
        else if model.iap.canMakePayments()
        {
            model.iap.observable.addObserver(observerName, observer: self)
            model.iap.requestProducts()
        }
    }
    //
    // This function is called twice, first when child view is added to parent
    // then secondly when it is removed, in this case parent is nil
    //
    override func willMoveToParentViewController(parent: UIViewController?)
    {
        //Only do something when moving back to parent
        if parent == nil
        {
            model.iap.observable.removeObserver(observerName)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK:- IAPDelegate
    func productsRequest(){
        if let product = model.iap.getProduct(IAPFactory.getGoProId())
        {
            dispatch_async(dispatch_get_main_queue())
            {
                self.buyButton.enabled=true
                self.buyButton.setTitle("Buy \(product.price)",forState: .Normal)
            }
        }
    }
    func purchaseRequest(productID : String){
        if (productID == IAPFactory.getGoProId()){
            dispatch_async(dispatch_get_main_queue())
            {
                self.buyButton.enabled=false
                self.buyButton.setTitle("Purchased",forState: .Normal)
                self.mpdbShowAlert("Purchase Complete",msg: "Thanks for purchasing the Go Pro upgrade, new features are now unlocked.")
            }
        }
    }
    func restoreRequest(productID : String){
        if (productID == IAPFactory.getGoProId()){
            dispatch_async(dispatch_get_main_queue())
            {
                self.buyButton.enabled=false
                self.buyButton.setTitle("Purchased",forState: .Normal)
                self.mpdbShowAlert("Purchase Restored",msg: "Go Pro purchase has been restored, Pro features are now unlocked.")
            }
        }
        
    }
    func purchaseFailed(productID : String){
        dispatch_async(dispatch_get_main_queue())
        {
            self.buyButton.enabled=true
            self.mpdbShowAlert("Purchase Failed",msg: "Sorry, unable to complete the purchase. You have not been charged.")
        }
    }
    
}
