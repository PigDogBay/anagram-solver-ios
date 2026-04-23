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
            SymbolBar(searchBarVM: appVM.searchBarVM)
                .padding(.bottom, 20) // Adjust height from the bottom edge
        }
    }
}
