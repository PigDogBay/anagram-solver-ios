//
//  RemoveAdsRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 17/02/2026.
//  Copyright © 2026 Mark Bailey. All rights reserved.
//

import SwiftUI

struct RemoveAdsRow: View {
    @State var storeVM : StoreViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "star")
                .font(Font.system(.largeTitle))
                .foregroundColor(Color("iconBlue"))
                .padding(3)
            
            VStack(alignment: .leading) {
                Text("Remove Ads").font(.title)
                // Show price or "Purchased" status
                Text(storeVM.storeStatus == .Purchased ? "Currently Active" : storeVM.price)
                    .font(.footnote)
            }
            Spacer()
        }
    }
}

#Preview {
    RemoveAdsRow(storeVM: StoreViewModel(productID: REMOVE_ADS_PRODUCT_ID))
}
