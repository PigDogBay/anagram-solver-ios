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

public enum PurchaseStatus {
    case unknown, verified, unverified, refunded(date: Date?), notFound
}

let REMOVE_ADS_PRODUCT_ID = "com.mpdbailey.ios.anagramsolver.gopro"

//@MainActor
@Observable
final class StoreViewModel {
    private let removeAdsID : String
    var storeStatus = StoreStatus.Unavailable
    var price = "£4.99"
    var errorMessage: String? = nil
    @ObservationIgnored var errorTitle : String? = nil
    @ObservationIgnored private var purchaseStatus = PurchaseStatus.unknown
    @ObservationIgnored var transaction: StoreKit.Transaction? = nil
    @ObservationIgnored private var product : Product?
    
    init(productID : String){
        self.removeAdsID = productID
        Task {
            await loadProduct()
            await refreshPurchasedStatus()
        }
        listenForTransaction()
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
        errorTitle = "Purchase Failed"

        let result = try? await product.purchase()
        switch result {
        case .success(let verificationResult):
            switch verificationResult {
            case .verified(let transaction):
                // Give the user access to purchased content.
                // Complete the transaction after providing
                // the user access to the content.
                await transaction.finish()
                //Call refresh as no update is sent in listenForUpdates()
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
            errorMessage = "No reason given"
        @unknown default:
            storeStatus = .Available
            errorMessage = "Unknown reason"
            break
        }
    }
    
    ///This code is called from init(), purchase(), listenForTransaction() and restorePurchase()
    ///Updates purchaseStatus
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
                    purchaseStatus = .verified
                } else {
                    //User has refunded the purchased
                    storeStatus = .Available
                    Settings().isProMode = false
                    purchaseStatus = .refunded(date: transaction.revocationDate)
                }
            case .unverified:
                storeStatus = .Available
                Settings().isProMode = false
                purchaseStatus = .unverified
            }
        } else {
            storeStatus = .Available
            Settings().isProMode = false
            purchaseStatus = .notFound
        }
    }
    
    ///This functions runs in the background, will respond to refunds which
    ///may arrive 24-48 hours after a request
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
        errorMessage = nil
        if storeStatus != .Purchased {
            storeStatus = .Restoring
            errorTitle = "Restore"
            Task {
                await refreshPurchasedStatus()
                switch purchaseStatus {
                case .unknown:
                    errorMessage = "Could not determine purchase status"
                case .verified:
                    errorMessage = "Purchase successfully restored"
                case .unverified:
                    errorMessage = "Purchase is unverified"
                case .refunded(let date):
                    errorMessage = "Purchase was refunded on \(date, default: "unknown")"
                case .notFound:
                    errorMessage = "Purchase was not found"
                }
            }
        }
    }
}

