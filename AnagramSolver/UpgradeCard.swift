//
//  UpgradeCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 23/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct UpgradeCard: View {
    private let coordinator = Coordinator.sharedInstance
    @ObservedObject var viewModel = AboutViewModel()
    
    private let storeVM = Model.sharedInstance.storeVM
    @State private var showRefundSheet = false
    
    private var showAlertBinding: Binding<Bool> {
        Binding(
            get: { storeVM.errorMessage != nil },
            set: {
                if !$0 {
                    Model.sharedInstance.storeVM.errorMessage = nil
                }
            }
        )
    }
    
    private var description : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            Text("* Remove Ads")
            Text("* One time purchase")
            Text("* More screen space")
        }
    }
    
    private var buttons : some View {
        HStack(){
            Button(action:storeVM.restorePurchase){
                Text("RESTORE PURCHASE")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
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
    
    var body: some View {
        VStack(alignment: .center) {
            CardTitle(title: "Upgrade", icon: "pro")
                .padding(.top,16)
            description
                .padding(.top,2)
            buttons
                .padding(16)
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
                title: Text("Purchase Failed"),
                message: Text(storeVM.errorMessage ?? "nil"),
                dismissButton: .default(Text("OK")
            ))
        }
        .onAppear{viewModel.onAppear()}
        .onDisappear{viewModel.onDisappear()}
    }

    private func refund(){
        if (storeVM.transaction) != nil {
            showRefundSheet = true
        }
    }

}

struct UpgradeCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UpgradeCard()
            UpgradeCard()
                .preferredColorScheme(.dark)
            
        }.previewLayout(.fixed(width: 300, height: 240))
    }
}
