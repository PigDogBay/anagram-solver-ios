//
//  StoreViewModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

/*
 In App Purchase Code
 
 Based on this tutorial
 https://www.youtube.com/watch?v=BI-ohzQ7GuI
 
 Docs:
 https://developer.apple.com/documentation/storekit/in-app-purchase
 https://developer.apple.com/in-app-purchase/#create-in-app-purchases
 
 */

import StoreKit
import Combine
import SwiftUI
import Observation

public enum StoreStatus {
    case Unavailable, Available, Purchasing, Pending, Purchased, Restoring
}

//@MainActor
public protocol StoreInterface
{
    var storeStatus : StoreStatus { get }
    var price: String { get }
    var errorMessage: String? { get set }
    var transaction : StoreKit.Transaction? { get }
    
    func buy()
    func restorePurchase()
}

@Observable
//@MainActor
final class MockStoreViewModel : StoreInterface {
    
    var storeStatus = StoreStatus.Unavailable
    var price = "£4.99"
    var errorMessage: String? = nil
    var transaction: StoreKit.Transaction? = nil

    init(){
        Task {
            await refresh()
        }
    }
    
    private func refresh() async {
        print("MOCK refresh()")
        await loadProduct()
    }
    
    private func loadProduct() async {
        print("MOCK loadProduct()")
        try? await Task.sleep(for: .seconds(3))
        storeStatus = .Available
    }
    
    private func purchase() async {
        print("MOCK purchase()")
        storeStatus = .Purchasing
        try? await Task.sleep(for: .seconds(3))
        //storeStatus = .Purchased
        
        storeStatus = .Available
        errorMessage = "There was an error processing the payment"
    }

    private func refreshPurchasedStatus() async {
        print("MOCK refreshPurchasedStatus()")
        try? await Task.sleep(for: .seconds(3))
        storeStatus = .Purchased
    }

    
    func buy(){
        print("MOCK buy")
        Task { await purchase()}
    }
    
    func restorePurchase(){
        print("MOCK restore")
        if storeStatus != .Purchased {
            storeStatus = .Restoring
            Task { await refreshPurchasedStatus() }
        }
    }
}


@Observable
//@MainActor
final class StoreViewModel : StoreInterface {
    private let removeAdsID = "com.mpdbailey.ios.anagramsolver.gopro"
    var storeStatus = StoreStatus.Unavailable
    var price = "£4.99"
    var errorMessage: String? = nil
    @ObservationIgnored var transaction: StoreKit.Transaction? = nil
    @ObservationIgnored private var product : Product?

    
    init(){
        Task {
            await refresh()
        }
        listenForTransaction()
    }
    
    private func refresh() async {
        await loadProduct()
        await refreshPurchasedStatus()
    }
    
    private func loadProduct() async {
        errorMessage = nil
        price = "Loading…"
        if let loaded = try? await Product.products(for: [removeAdsID])
            .first {
            product = loaded
            price = loaded.displayPrice
            storeStatus = .Available
        } else {
            storeStatus = .Unavailable
        }
    }
    
    private func purchase() async {
        guard let product else { return }
        storeStatus = .Purchasing
        errorMessage = nil

        let result = try? await product.purchase()
        switch result {
        case .success(let verificationResult):
            switch verificationResult {
            case .verified(let transaction):
                // Give the user access to purchased content.
                // Complete the transaction after providing
                // the user access to the content.
                await transaction.finish()
                await refreshPurchasedStatus()
            case .unverified(_, let error):
                storeStatus = .Available
                errorMessage = "Unverified transaction: \(error)"
            }
        case .pending:
            storeStatus = .Pending
        case .userCancelled:
            storeStatus = .Available
        case .none:
            storeStatus = .Available
            errorMessage = "No reason given."
        @unknown default:
            storeStatus = .Available
            errorMessage = "Unknown reason."
            break
        }
    }

    private func refreshPurchasedStatus() async {
        transaction = nil
        // For a non-consumable, latest(for:) is an easy way to check entitlement
        if let result = await Transaction.latest(for: removeAdsID) {
            switch result {
            case .verified(let transaction):
                // Consider revoked or upgraded transactions as not currently owned
                if (transaction.revocationDate == nil) && !transaction.isUpgraded {
                    storeStatus = .Purchased
                    self.transaction = transaction
                    Settings().isProMode = true
                } else {
                    //User has refunded the purchased
                    storeStatus = .Available
                    Settings().isProMode = false
                }
            case .unverified:
                storeStatus = .Available
                Settings().isProMode = false
            }
        } else {
            errorMessage = "No transaction found"
            storeStatus = .Available
        }
    }

    private func listenForTransaction() {
        Task {
            for await update in Transaction.updates {
                if case .verified(let transaction) = update {
                    await transaction.finish()
                    await refreshPurchasedStatus()
                }
            }
        }
    }

    func buy(){
        Task { await purchase()}
    }
    
    func restorePurchase(){
        if storeStatus != .Purchased {
            storeStatus = .Restoring
            Task { await refreshPurchasedStatus() }
        }
    }
}

