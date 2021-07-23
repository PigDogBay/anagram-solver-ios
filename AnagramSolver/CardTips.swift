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
    let columns = [GridItem(.adaptive(minimum: 350))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                
                Group {
                    TipCard(tip: anagramTip, coordinator: coordinator)
                        .modifier(CardMod())
                    TipCard(tip: blankLettersTip, coordinator: coordinator)
                        .modifier(CardMod())
                    DefinitionsCard()
                        .modifier(CardMod())
                    FilterCard()
                        .modifier(CardMod())
                    TipCard(tip: twoWordAnagramTip, coordinator: coordinator)
                        .modifier(CardMod())
                    SettingsCard()
                        .modifier(CardMod())
                    TipCard(tip: crosswordTip, coordinator: coordinator)
                        .modifier(CardMod())
                    TipCard(tip: shortcutsTip, coordinator: coordinator)
                        .modifier(CardMod())
                    TipCard(tip: supergramsTip, coordinator: coordinator)
                        .modifier(CardMod())
                }
                Group {
                    TipCard(tip: codewordsTip, coordinator: coordinator)
                        .modifier(CardMod())
                    TipCard(tip: prefixSuffixTip, coordinator: coordinator)
                        .modifier(CardMod())
                    AboutCard(coordinator: coordinator)
                        .modifier(CardMod())
                    UserGuideCard()
                        .modifier(CardMod())
                    HelpOutCard(coordinator: coordinator)
                        .modifier(CardMod())
                    UpgradeCard(coordinator: coordinator)
                        .modifier(CardMod())
                    #if DEBUG
                    AutoTestCard(coordinator: coordinator)
                        .modifier(CardMod())
                    #endif
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 48)
        }
        .background(Color("tipsBackground"))
        .gesture(DragGesture().onChanged { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        })
        .ignoresSafeArea()
    }
}

struct CardMod : ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color("cardBackground"))
            .cornerRadius(5.0)
            .shadow(radius: 2)
    }
}

@available(iOS 14.0, *)
struct CardTips_Previews: PreviewProvider {
    static var previews: some View {
        CardTips(coordinator: Coordinator())
    }
}
