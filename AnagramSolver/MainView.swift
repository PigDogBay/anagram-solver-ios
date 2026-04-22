//
//  MainView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 11/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUI
import SwiftUtils

struct MainView: View {
    @Environment(AppViewModel.self) var appVM
    @AppStorage(Keys.showCardTips) var showCardTips: Bool = Settings().showCardTips
    
    // Define the symbols and their corresponding SF Symbol names
    let symbols = [
        ("?", "questionmark"),
        ("+", "plus"),
        ("*", "asterisk"),
        ("$", "dollarsign"),
        ("@", "at")
    ]
    
    @ViewBuilder
    var body: some View {
        VStack(spacing: 0){         //Spacing 0: Remove white gap between search bar and tips
            SearchBarView(searchBarVM: appVM.searchBarVM)
            if showCardTips {
                CardTips(searchHistoryVM: SearchHistoryCardViewModel(appVM.model.searchHistoryModel))
            } else {
                TipsView(searchHistoryVM: SearchHistoryRowViewModel(appVM.model.searchHistoryModel))
                    .ignoresSafeArea()
            }
        }
        .navigationTitle("Anagram Solver")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarIconButton(placement: .topBarLeading, iconName: "gear") {appVM.goto(screen: .Settings)}
            if (appVM.canSearch()){
                ToolbarButton(placement: .topBarTrailing, label: "Search"){
                    if appVM.searchBarVM.isValid() {
                        appVM.search()
                    } else {
                        appVM.searchBarVM.showValidationError = true
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .overlay(alignment: .bottom) {
            symbolCapsule
                .padding(.bottom, 20) // Adjust height from the bottom edge
        }
    }
    
    // The Glass Capsule View
    var symbolCapsule: some View {
        HStack(spacing: 25) {
            ForEach(symbols, id: \.0) { char, icon in
                Button {
                    symbolPressed(symbol: char)
                } label: {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("accentColor"))
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 25)
        .background(.ultraThinMaterial) // The "Glass" effect
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(.white.opacity(0.2), lineWidth: 0.5) // Subtle border for depth
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
    }

    func symbolPressed(symbol: String) {
        // Handle the symbol insertion logic here
        print("Pressed: \(symbol)")
        appVM.searchBarVM.query.append(symbol)
    }

}
