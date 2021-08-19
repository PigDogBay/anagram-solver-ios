//
//  HomeView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 22/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var coordinator : Coordinator
    var body: some View {
        if #available(iOS 14.0, *) {
            if coordinator.showCards {
                CardTips(coordinator: coordinator)
            } else {
                TipsView(coordinator: coordinator)
                    .ignoresSafeArea()
            }
        } else {
            TipsView(coordinator: coordinator)
        }
        NavigationLink(destination: AboutView(coordinator: coordinator),
                       tag: coordinator.SHOW_ABOUT,
                       selection: $coordinator.selection){
            EmptyView()
        }
        NavigationLink(destination: DefinitionHelpView(),
                       tag: coordinator.SHOW_DEFINITION_HELP,
                       selection: $coordinator.selection){
            EmptyView()
        }
        NavigationLink(destination: HelpView(coordinator: coordinator, viewModel: HelpViewModel(tip: coordinator.tip)),
                       tag: coordinator.SHOW_HELP,
                       selection: $coordinator.selection){
            EmptyView()
        }
        NavigationLink(destination: SettingsHelpView(),
                       tag: coordinator.SHOW_SETTINGS_HELP,
                       selection: $coordinator.selection){
            EmptyView()
        }
        NavigationLink(destination: SettingsView(coordinator: coordinator),
                       tag: coordinator.SHOW_SETTINGS,
                       selection: $coordinator.selection){
            EmptyView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(coordinator: Coordinator())
    }
}
