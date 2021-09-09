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
    private let coordinator = Coordinator.sharedInstance
    let columns = [GridItem(.adaptive(minimum: 350))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                
                Group {
                    TipCard(tip: anagramTip)
                        .modifier(CardMod())
                    TipCard(tip: blankLettersTip)
                        .modifier(CardMod())
                    DefinitionsCard()
                        .modifier(CardMod())
                    FilterCard()
                        .modifier(CardMod())
                    TipCard(tip: twoWordAnagramTip)
                        .modifier(CardMod())
                    SettingsCard()
                        .modifier(CardMod())
                    TipCard(tip: crosswordTip)
                        .modifier(CardMod())
                    TipCard(tip: phraseTip)
                        .modifier(CardMod())
                    TipCard(tip: shortcutsTip)
                        .modifier(CardMod())
                    TipCard(tip: supergramsTip)
                        .modifier(CardMod())
                }
                Group {
                    TipCard(tip: codewordsTip)
                        .modifier(CardMod())
                    TipCard(tip: prefixSuffixTip)
                        .modifier(CardMod())
                    AboutCard()
                        .modifier(CardMod())
                    TipCard(tip: spellingBeeTip)
                        .modifier(CardMod())
                    UserGuideCard()
                        .modifier(CardMod())
                    HelpOutCard()
                        .modifier(CardMod())
                    UpgradeCard()
                        .modifier(CardMod())
                    #if DEBUG
                    AutoTestCard()
                        .modifier(CardMod())
                    #endif
                }
            }
            .padding(.horizontal,8)
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
        CardTips()
    }
}
