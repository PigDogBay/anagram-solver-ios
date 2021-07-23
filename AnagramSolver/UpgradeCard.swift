//
//  UpgradeCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 23/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct UpgradeCard: View {
    @ObservedObject var coordinator : Coordinator

    private var description : some View {
        VStack(alignment: .leading, spacing: 5){
            Text("* Remove Ads")
            Text("* One time purchase")
            Text("* More screen space")
        }
    }

    private var buttons : some View {
        HStack(){
            Spacer()
            Button(action:{}){
                Text("BUY")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
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
    }
}

struct UpgradeCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UpgradeCard(coordinator: Coordinator())
            UpgradeCard(coordinator: Coordinator())
                .preferredColorScheme(.dark)
            
        }.previewLayout(.fixed(width: 300, height: 240))
    }
}
