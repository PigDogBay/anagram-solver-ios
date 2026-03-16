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
    @Environment(AppViewModel.self) var appViewModel
    @Environment(SearchBarViewModel.self) var searchBarVM
    @AppStorage(Keys.showCardTips) var showCardTips: Bool = Settings().showCardTips

    @ViewBuilder
    var body: some View {
        VStack(spacing: 0){         //Spacing 0: Remove white gap between search bar and tips
            SearchBarView(searchBarVM: searchBarVM)
            if showCardTips {
                CardTips()
            } else {
                TipsView()
                    .ignoresSafeArea()
            }
        }
        .navigationTitle("Anagram Solver")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarIconButton(placement: .topBarLeading, iconName: "gear") {appViewModel.goto(screen: .Settings)}
            if (appViewModel.appState == .ready){
                ToolbarButton(placement: .topBarTrailing, label: "Search"){appViewModel.goto(screen: .Matches)}
            }
        }

    }
}
