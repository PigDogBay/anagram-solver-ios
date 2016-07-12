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

public class IAPHelper : NSObject, IAPInterface, SKProductsRequestDelegate, SKPaymentTransactionObserver
{
    public var productIdentifiers = Set<String>()
    
    private var products : [SKProduct] = []
    
    private let currencyFormatter : NSNumberFormatter

    public override init(){
        self.observable = IAPObservable()
        currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        currencyFormatter.formatterBehavior = .Behavior10_4
        
        super.init()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    private func createIAPProduct(product: SKProduct)->IAPProduct{
        currencyFormatter.locale = product.priceLocale
        return IAPProduct(id: product.productIdentifier,
                          price: currencyFormatter.stringFromNumber(product.price)!,
                          title: product.localizedTitle,
                          description: product.description)
        
    }
    private func getSKProduct(productID:String)->SKProduct?{
        for p in products {
            if p.productIdentifier == productID{
                return p
            }
        }
        return nil
    }

    //MARK:- IAPInterface
    public var observable : IAPObservable
    
    public func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    public func requestProducts(){
        let request = SKProductsRequest(productIdentifiers: self.productIdentifiers)
        request.delegate = self
        request.start()
    }
    public func requestPurchase(productID : String){
        if let skproduct = getSKProduct(productID)
        {
            let payment = SKPayment(product: skproduct)
            SKPaymentQueue.defaultQueue().addPayment(payment)
        }
    }
    public func restorePurchases(){
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    public func getProduct(productID : String) -> IAPProduct?
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
    public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        self.products = response.products
        self.observable.onProductsRequestCompleted()
    }
    
    //MARK:- SKPaymentTransactionObserver
    public func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch (transaction.transactionState){
            case .Deferred:
                deferredTransaction(transaction)
                break
            case .Failed:
                failedTransaction(transaction)
                break
            case .Purchased:
                purchasedTransaction(transaction)
                break
            case .Purchasing:
                purchasingTransaction(transaction)
                break
            case .Restored:
                restoredTransaction(transaction)
                break
            }
        }
    }
    
    private func deferredTransaction(transaction: SKPaymentTransaction){
        print("Transaction: deferred")
    }
    private func failedTransaction(transaction: SKPaymentTransaction){
        print("Transaction: failed")
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        let productID = transaction.payment.productIdentifier
        observable.onPurchaseRequestFailed(productID)
    }
    private func purchasingTransaction(transaction: SKPaymentTransaction){
        print("Transaction: purchasing")
    }
    private func purchasedTransaction(transaction: SKPaymentTransaction){
        print("Transaction: purchased")
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        let productID = transaction.payment.productIdentifier
        observable.onPurchaseRequestCompleted(productID)
    }
    private func restoredTransaction(transaction: SKPaymentTransaction){
        print("Transaction: restored")
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        let productID = transaction.payment.productIdentifier
        observable.onRestorePurchaseCompleted(productID)

    }
    
}