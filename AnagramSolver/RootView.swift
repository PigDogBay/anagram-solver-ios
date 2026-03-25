//
//  NMARootView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 11/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppViewModel.self) var appVM
    
    //Don't use @Query for filters, as it will cause an update every time the filters are changed
    //Filters will be retrieved from the model container in .onAppear()
    @State private var filters : Filters?
    
    private let formViewControllerRepresentable = FormViewControllerRepresentable()
    
    @ViewBuilder
    var body: some View {
        NavigationStack(path: Bindable(appVM).path){
            MainView()
                .navigationDestination(for: NavigationScreens.self) { destination in
                    switch (destination){
                    case .Matches:MatchesView(
                        query: appVM.searchBarVM.query,
                        model: appVM.model,
                        filters: filters ?? Filters()
                    )
                    case .Tip(let tip): HelpView(tip: tip)
                    case .Definition: DefinitionView(appVM.model.engine)
                    case .Settings: SettingsView()
                    case .Filters: FiltersView(filters: filters ?? Filters())
                    case .DefinitionHelp: DefinitionHelpView()
                    case .FiltersHelp: FilterHelpView()
                    case .SettingsHelp: SettingsHelpView()
                    case .About: AboutView(viewModel: AboutViewModel(ads: appVM.ads))
                    case .RemoveAdsDetail: RemoveAdsDetailView()
                    case .SearchHistory: SearchHistoryView(
                        viewModel: SearchHistoryViewVM(appVM.model.searchHistoryModel))
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
            if filters == nil{
                let descriptor = FetchDescriptor<Filters>()
                // Fetch manually from the context
                filters = try? modelContext.fetch(descriptor).first
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
