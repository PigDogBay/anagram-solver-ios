//
//  CardTips.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 16/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct CardTips: View {
    @ObservedObject var coordinator : Coordinator
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(tipsData) { tip in
                    TipCard(tip: tip, coordinator: coordinator)
                        .background(Color("cardBackground"))
                        .cornerRadius(5.0)
                        .shadow(radius: 2)
                        .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                }
            }.padding(.top, 8)
        }.background(Color("tipsBackground"))
        .gesture(DragGesture().onChanged { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        })
    }
}

@available(iOS 14.0, *)
struct CardTips_Previews: PreviewProvider {
    static var previews: some View {
        CardTips(coordinator: Coordinator())
    }
}
