//
//  GoProViewController.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/06/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import UIKit
import StoreKit

class GoProViewController: UIViewController, SKProductsRequestDelegate {
    private static let productId = "com.mpdbailey.ios.anagramsolver.gopro"
    private let productIdentifiers = Set([productId])
    private var product: SKProduct?

    @IBOutlet weak var statusLabel: UILabel!
    @IBAction func stdBtnClick(sender: AnyObject)
    {
        model.stdMode()
        modelToView()
    }
    @IBAction func proBtnClicked(sender: AnyObject) {
        model.proMode()
        modelToView()
    }

    private var model : Model!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = Model.sharedInstance
        modelToView()
        requestProductData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func modelToView(){
        statusLabel.text = model.isProMode ? "Pro" : "Standard"
    }
    
    func requestProductData(){
        if (SKPaymentQueue.canMakePayments()){
            let request = SKProductsRequest(productIdentifiers: self.productIdentifiers)
            request.delegate = self
            request.start()
        }
        else
        {
            //show alert that user can not make payment
            print("Cannot make payment")
        }
    }
    
    // MARK:- SKProductsRequestDelegate
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if (response.products.count == 0){
            print("No products found")
            return
        }
        self.product = response.products[0]
        print("Product \(self.product?.localizedTitle) \(self.product?.price)")
        print(self.product?.localizedDescription)
        
    }

}
