//
//  RemoveAdsDetailView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 17/02/2026.
//  Copyright © 2026 Mark Bailey. All rights reserved.
//

import SwiftUI

struct RemoveAdsDetailView: View {
    private let storeVM = Model.sharedInstance.storeVM
    @State private var showRefundSheet = false
    
    private var showAlertBinding: Binding<Bool> {
        Binding(
            get: { storeVM.errorMessage != nil },
            set: {
                if !$0 {
                    storeVM.errorMessage = nil
                }
            }
        )
    }

    var body: some View {
        Form {
            
            Section(footer: Text("If you have already purchased the option to remove ads, press the restore button above to retrieve your purchase details."))
            {
                VStack(alignment: .leading, spacing: 16) {
                    HelpTitleView(title: "Remove Ads", icon: "pro")
                    if storeVM.storeStatus == .Purchased{
                        Text("Thank you for your purchase to remove ads. You may request to refund this purchase by pressing the button below. Requests are sent to Apple and take 24 to 48 hours to process.")
                            .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    } else {
                        Text("The app is funded by showing a banner ad at the bottom of the screen. You may remove advertisements by making a one time purchase. This purchase will be available to all of your devices and includes Family Sharing.")
                            .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    }
                    HStack {
                        Spacer()
                        switch storeVM.storeStatus {
                        case .Unavailable:
                            Text("Unavailable")
                        case .Available:
                            Button(action: storeVM.buy){
                                Text("BUY \(storeVM.price)")
                                    .modifier(TipButtonMod())
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                        case .Purchasing:
                            ProgressView("Processing purchase…")
                                .progressViewStyle(.circular)
                                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                        case .Pending:
                            ProgressView("Purchase pending…")
                                .progressViewStyle(.circular)
                                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                        case .Purchased:
                            Button(action: refund){
                                Text("REFUND THIS PURCHASE")
                                    .modifier(TipButtonMod())
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                        case .Restoring:
                            ProgressView("Restoring purchase…")
                                .progressViewStyle(.circular)
                                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                        }
                    }
                }
            }
            Section("HELP"){
                FilterSectionView(title: "REFUNDS", description: "If you wish to request a refund, you can do so within the app or by signing in to reportaproblem.apple.com, refunds take 24 to 48 hours after the request.")
                FilterSectionView(title: "USER ID", description: "If you have made an in-app purchase, it is tied to your Apple user ID (e.g. email address). To use the purchase on your other devices, ensure you are signed-in using the same user ID.")
                FilterSectionView(title: "ONE TIME", description: "The Remove Ads in-app purchase is a one time payment that does not expire.")
                FilterSectionView(title: "RESTORE", description: "You can restore a purchase by pressing the restore button (top-right on the tool bar). You will need to do this if you have re-installed the app.")
                FilterSectionView(title: "SUPPORT", description: "If you need further assistance, use the Feedback button on the main screen to send us (MPD Bailey Technology) an email and we will endeavour to reply to you as soon as possible.")
            }
        }
        .refundRequestSheet(
            for: storeVM.transaction?.id ?? 0,
            isPresented: $showRefundSheet){ result in
                switch result {
                case .success(let status):
                    print("Refund status \(status)")
                case .failure(let error):
                    print("Refund failed: \(error)")
                }
            }
        .alert(isPresented: showAlertBinding){
            Alert(
                title: Text(storeVM.errorTitle ?? "Purchase Update"),
                message: Text(storeVM.errorMessage ?? "nil"),
                dismissButton: .default(Text("OK")
            ))
        }
        .navigationTitle("Remove Ads")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Restore"){
            storeVM.restorePurchase()
        }.tint(Color.white))
    }
    
    private func refund(){
        if (storeVM.transaction) != nil {
            showRefundSheet = true
        }
    }
}

#Preview {
    RemoveAdsDetailView()
}
