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

    private var description : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            Text("* Remove Ads")
            Text("* One time purchase")
            Text("* More screen space")
        }
    }

    private var buttons : some View {
        HStack(){
            Button(action:viewModel.restorePurchase){
                Text("RESTORE PURCHASE")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action:viewModel.buy){
                Text(viewModel.buyButtonText)
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
            .disabled(!viewModel.buyButtonEnabled)
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
        .alert(isPresented: $viewModel.showAlertRestored){
            Alert(title: Text("Purchase Restored"), message: Text("Your purchase has been restored, Ads have now been removed"), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $viewModel.showAlertFailed){
            Alert(title: Text("Purchase Failed"), message: Text("Sorry, unable to complete the purchase. You have not been charged."), dismissButton: .default(Text("OK")))
        }
        .onAppear{viewModel.onAppear()}
        .onDisappear{viewModel.onDisappear()}
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
