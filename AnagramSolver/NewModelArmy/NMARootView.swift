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
    private let formViewControllerRepresentable = FormViewControllerRepresentable()

    
    @ViewBuilder
    var body: some View {
        NavigationStack(path: Bindable(appViewModel).path){
            MainView()
                .navigationDestination(for: NavigationScreens.self) { destination in
                    switch (destination){
                    case .Matches: MatchesView(matchesVM: appViewModel.createMatchesVM())
                        //            case .Tip(let index): HelpView(tip: tipsData[index])
                    case .Tip(let index): SettingsView()
                        //            case .Definition: DefinitionView(coordinator.model)
                    case .Definition : SettingsView()
                    case .Settings: SettingsView()
                        //            case .Filters: FiltersView(filters: viewModel.model.filters)
                    case .Filters: FiltersView(filters: appViewModel.filtersVM)
                    case .DefinitionHelp: DefinitionHelpView()
                    case .FiltersHelp: FilterHelpView()
                    case .SettingsHelp: SettingsHelpView()
                    case .About: AboutView()
                    case .RemoveAdsDetail: RemoveAdsDetailView()
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
            appViewModel.onLaunch()
            if !appViewModel.settings.isProMode {
                appViewModel.ads.setUp(viewControler: formViewControllerRepresentable.viewController)
            }

        }
        .alert(isPresented: appViewModel.showErrorAlert){
            Alert(
                title: Text("Error Detected"),
                message: Text("Restart the app or press OK to reload the word list."),
                dismissButton: .default(Text("OK")
                                       ))
        }

    }
}
