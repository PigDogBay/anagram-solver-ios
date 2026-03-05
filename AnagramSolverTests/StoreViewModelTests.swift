//
//  StoreViewModelTests.swift
//  CrosswordSolverKingTests
//
//  Created by Mark Bailey on 04/03/2026.
//  Copyright © 2026 Mark Bailey. All rights reserved.
//

/*
 Notes
 Ensure InAppPurchaseStore.config Target Membership is added to CrosswordSolverKingTests
 */


import Testing
import StoreKit
import StoreKitTest

///.serialized prevents reentrance, tests now run one at a time
@MainActor
@Suite("StoreViewModel tests", .serialized)
struct StoreViewModelTests {
    
    var storeVM : StoreViewModel
    
    init() async throws {
        storeVM = StoreViewModel(productID: REMOVE_ADS_PRODUCT_ID)
        Settings().isProMode = false
    }
    
    @available(iOS 26.0, *)
    @Test func price1() async throws {
        let session = try SKTestSession(configurationFileNamed: "InAppPurchaseStore")
        session.disableDialogs = true
        session.clearTransactions()
        try await Task.sleep(for: .seconds(1))
        #expect(storeVM.price == "$4.99")
        session.resetToDefaultState()
    }

    @available(iOS 26.0, *)
    @Test func buy1() async throws {
        let session = try SKTestSession(configurationFileNamed: "InAppPurchaseStore")
        session.disableDialogs = true
        session.clearTransactions()
        try await Task.sleep(for: .seconds(1))
        storeVM.buy()
        try await Task.sleep(for: .seconds(1))
        #expect(storeVM.storeStatus == .Purchased)
        let adsRemoved = Settings().isProMode
        #expect(adsRemoved)
        session.resetToDefaultState()
    }
    
    /*
     This test also checks that storeVM is listening to transactions
     as the buy and refund are done thru the session
     */
    @available(iOS 26.0, *)
    @Test func refund1() async throws {
        let session = try SKTestSession(configurationFileNamed: "InAppPurchaseStore")
        session.disableDialogs = true
        session.clearTransactions()
        try await Task.sleep(for: .seconds(1))
        let transaction = try await session.buyProduct(identifier: REMOVE_ADS_PRODUCT_ID)
        try await Task.sleep(for: .seconds(1))
        #expect(storeVM.storeStatus == .Purchased)
        try session.refundTransaction(identifier: UInt(transaction.id))
        try await Task.sleep(for: .seconds(1))
        #expect(storeVM.storeStatus == .Available)
        let adsRemoved = Settings().isProMode
        #expect(!adsRemoved)
        session.resetToDefaultState()
    }

    @available(iOS 26.0, *)
    @Test func pending1() async throws {
        let session = try SKTestSession(configurationFileNamed: "InAppPurchaseStore")
        session.disableDialogs = true
        session.clearTransactions()
        session.askToBuyEnabled = true
        try await Task.sleep(for: .seconds(1))
        storeVM.buy()
        try await Task.sleep(for: .seconds(1))
        #expect(storeVM.storeStatus == .Pending)
        session.resetToDefaultState()
    }
    
}
