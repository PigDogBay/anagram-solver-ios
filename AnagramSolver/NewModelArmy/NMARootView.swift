//
//  NMARootView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 11/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct NMARootView: View {
    @Environment(AppViewModel.self) var appVM
    @Environment(FiltersViewModel.self) var filtersVM
    
    private let formViewControllerRepresentable = FormViewControllerRepresentable()
    
    @ViewBuilder
    var body: some View {
        NavigationStack(path: Bindable(appVM).path){
            MainView()
                .navigationDestination(for: NavigationScreens.self) { destination in
                    switch (destination){
                    case .Matches:MatchesView(
                        matchesVM: MatchesViewModel(
                            query: appVM.searchBarVM.query,
                            engine: appVM.engine,
                            filtersVM: filtersVM)
                    )
                    case .Tip(let tip): HelpView(tip: tip)
                        //            case .Definition: DefinitionView(coordinator.model)
                    case .Definition : SettingsView()
                    case .Settings: SettingsView()
                    case .Filters: FiltersView(filters: filtersVM)
                    case .DefinitionHelp: DefinitionHelpView()
                    case .FiltersHelp: FilterHelpView()
                    case .SettingsHelp: SettingsHelpView()
                    case .About: AboutView(viewModel: AboutViewModel(ads: appVM.ads))
                    case .RemoveAdsDetail: RemoveAdsDetailView()
                    case .SearchHistory: SearchHistoryView(
                        viewModel: SearchHistoryViewVM(appVM.searchHistoryModel))
                    }
                }
        }
        .background {
            // Add the ViewControllerRepresentable to the background so it
            // doesn't influence the placement of other views in the view hierarchy.
            formViewControllerRepresentable
                .frame(width: .zero, height: .zero)
        }
        .onAppear(){
            appVM.onLaunch()
            if !appVM.settings.isProMode {
                appVM.ads.setUp(viewControler: formViewControllerRepresentable.viewController)
            }

        }
        .alert(isPresented: appVM.showErrorAlert){
            Alert(
                title: Text("Error Detected"),
                message: Text("Restart the app or press OK to reload the word list."),
                dismissButton: .default(Text("OK")
                                       ))
        }

    }
}
