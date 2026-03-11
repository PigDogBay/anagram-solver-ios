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
    @Environment(AppViewModel.self) var coordinator
    
    @ViewBuilder
    var body: some View {
        VStack(spacing: 0){         //Spacing 0: Remove white gap between search bar and tips
            SearchBarView(searchBarVM: coordinator.searchBarVM)
            if Settings().showCardTips {
                CardTips()
            } else {
                TipsView()
                    .ignoresSafeArea()
            }
        }
        .navigationTitle("Anagram Solver")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarIconButton(placement: .topBarLeading, iconName: "gear") {coordinator.goto(screen: .Settings)}
            ToolbarButton(placement: .topBarTrailing, label: "Search"){coordinator.goto(screen: .Filters)}
        }

    }
}
