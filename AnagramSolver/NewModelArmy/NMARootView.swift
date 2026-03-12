//
//  NMARootView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 11/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct NMARootView: View {
    @Environment(AppViewModel.self) var appViewModel
    
    @ViewBuilder
    var body: some View {
        NavigationStack(path: Bindable(appViewModel).path){
            MainView()
                .navigationDestination(for: NavigationScreens.self) { destination in
                    switch (destination){
                    case .Matches: MatchesView(matchesVM: MatchesViewModel(
                        query: appViewModel.query,
                        engine: appViewModel.engine))
                        
        //            case .Tip(let index): HelpView(tip: tipsData[index])
                    case .Tip(let index): SettingsView()
        //            case .Definition: DefinitionView(coordinator.model)
                    case .Definition : SettingsView()
                    case .Settings: SettingsView()
        //            case .Filters: FiltersView(filters: viewModel.model.filters)
                    case .Filters: SettingsView()
                    case .DefinitionHelp: DefinitionHelpView()
                    case .FiltersHelp: FilterHelpView()
                    case .SettingsHelp: SettingsHelpView()
                    case .About: AboutView()
                    case .RemoveAdsDetail: RemoveAdsDetailView()
                    }
                }
        }
    }
}
