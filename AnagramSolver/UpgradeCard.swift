//
//  UpgradeCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 23/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct UpgradeCard: View {
    
    @Environment(AppViewModel.self) var appVM
    @Environment(StoreViewModel.self) var storeVM
    
    private var description : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            Text("* No more ads")
            Text("* One time purchase")
            Text("* More screen space")
        }
    }
    
    private var buttons : some View {
        HStack(){
            Button(action:{appVM.goto(screen: .RemoveAdsDetail)}){
                Text("MORE INFO")
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
                Text("Purchased")
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
            CardTitle(title: "Remove Ads", icon: "pro")
                .padding(.top,16)
            description
                .padding(.top,2)
            buttons
                .padding(16)
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
