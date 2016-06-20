//
//  IAPHelper.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 18/06/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//
//  Based on code https://www.raywenderlich.com/122144/in-app-purchase-tutorial
//

import StoreKit

public class IAPHelper : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver
{
    private static let productId = "com.mpdbailey.ios.anagramsolver.gopro"
    private let productIdentifiers = Set([productId])
    private var product: SKProduct?

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
    public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if (response.products.count == 0){
            print("No products found")
            return
        }
        self.product = response.products[0]
        print("Product \(self.product?.localizedTitle) \(self.product?.price)")
        print(self.product?.localizedDescription)
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
    }
    private func purchasingTransaction(transaction: SKPaymentTransaction){
        print("Transaction: purchasing")
    }
    private func purchasedTransaction(transaction: SKPaymentTransaction){
        print("Transaction: purchased")
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    private func restoredTransaction(transaction: SKPaymentTransaction){
        print("Transaction: restored")
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
}