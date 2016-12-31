//
//  IAPHelper.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 18/06/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//
//

import StoreKit
import SwiftUtils

open class IAPHelper : NSObject, IAPInterface, SKProductsRequestDelegate, SKPaymentTransactionObserver
{
    open var productIdentifiers = Set<String>()
    
    fileprivate var products : [SKProduct] = []
    
    fileprivate let currencyFormatter : NumberFormatter

    public override init(){
        self.observable = IAPObservable()
        currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.formatterBehavior = .behavior10_4
        
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    fileprivate func createIAPProduct(_ product: SKProduct)->IAPProduct{
        currencyFormatter.locale = product.priceLocale
        return IAPProduct(id: product.productIdentifier,
                          price: currencyFormatter.string(from: product.price)!,
                          title: product.localizedTitle,
                          description: product.description)
        
    }
    fileprivate func getSKProduct(_ productID:String)->SKProduct?{
        for p in products {
            if p.productIdentifier == productID{
                return p
            }
        }
        return nil
    }

    //MARK:- IAPInterface
    open var observable : IAPObservable
    
    open func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    open func requestProducts(){
        let request = SKProductsRequest(productIdentifiers: self.productIdentifiers)
        request.delegate = self
        request.start()
    }
    open func requestPurchase(_ productID : String){
        if let skproduct = getSKProduct(productID)
        {
            let payment = SKPayment(product: skproduct)
            SKPaymentQueue.default().add(payment)
        }
    }
    open func restorePurchases(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    open func getProduct(_ productID : String) -> IAPProduct?
    {
        for p in products
        {
            if p.productIdentifier == productID {
                return createIAPProduct(p)
            }
        }
        return nil
    }

    // MARK:- SKProductsRequestDelegate
    open func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        self.observable.onProductsRequestCompleted()
    }
    
    //MARK:- SKPaymentTransactionObserver
    open func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch (transaction.transactionState){
            case .deferred:
                deferredTransaction(transaction)
                break
            case .failed:
                failedTransaction(transaction)
                break
            case .purchased:
                purchasedTransaction(transaction)
                break
            case .purchasing:
                purchasingTransaction(transaction)
                break
            case .restored:
                restoredTransaction(transaction)
                break
            }
        }
    }
    
    fileprivate func deferredTransaction(_ transaction: SKPaymentTransaction){
        print("Transaction: deferred")
    }
    fileprivate func failedTransaction(_ transaction: SKPaymentTransaction){
        print("Transaction: failed")
        SKPaymentQueue.default().finishTransaction(transaction)
        let productID = transaction.payment.productIdentifier
        observable.onPurchaseRequestFailed(productID)
    }
    fileprivate func purchasingTransaction(_ transaction: SKPaymentTransaction){
        print("Transaction: purchasing")
    }
    fileprivate func purchasedTransaction(_ transaction: SKPaymentTransaction){
        print("Transaction: purchased")
        SKPaymentQueue.default().finishTransaction(transaction)
        let productID = transaction.payment.productIdentifier
        observable.onPurchaseRequestCompleted(productID)
    }
    fileprivate func restoredTransaction(_ transaction: SKPaymentTransaction){
        print("Transaction: restored")
        SKPaymentQueue.default().finishTransaction(transaction)
        let productID = transaction.payment.productIdentifier
        observable.onRestorePurchaseCompleted(productID)

    }
    
}
