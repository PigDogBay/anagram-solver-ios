//
//  CardTips.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 16/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct CardTips: View {
    @ObservedObject var coordinator : Coordinator
    
    var body: some View {
        List {
            ForEach(tipsData) { tip in
                TipCard(tip: tip, coordinator: coordinator)
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .shadow(radius: 2)
                    .listRowBackground(Color("tipsBackground"))
            }
        }
        .gesture(DragGesture().onChanged { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        })
    }
}

struct CardTips_Previews: PreviewProvider {
    static var previews: some View {
        CardTips(coordinator: Coordinator(rootVC: RootViewController()))
    }
}
