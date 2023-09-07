//
//  HomeView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 22/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var coordinator = Coordinator.sharedInstance


    /*
     There is a bug where navigation links appear as empty boxes when
     Settings->Accessibility->Display->Button Shapes enabled
     Setting the button style to plain removes the empty shapes and white space at the bottom of the screen
     https://stackoverflow.com/questions/70223291/eliminate-navigationlink-button-shape-in-accessibility-mode
    */
    var body: some View {
        if coordinator.showCards {
            CardTips()
        } else {
            TipsView()
                .ignoresSafeArea()
        }
        NavigationLink(destination: AboutView(),
                       tag: coordinator.SHOW_ABOUT,
                       selection: $coordinator.selection){
            EmptyView()
        }.buttonStyle(.plain)
        NavigationLink(destination: DefinitionHelpView(),
                       tag: coordinator.SHOW_DEFINITION_HELP,
                       selection: $coordinator.selection){
            EmptyView()
        }.buttonStyle(.plain)
        NavigationLink(destination: FilterHelpView(),
                       tag: coordinator.SHOW_FILTER_HELP,
                       selection: $coordinator.selection){
            EmptyView()
        }.buttonStyle(.plain)
        NavigationLink(destination: HelpView(viewModel: HelpViewModel(tip: coordinator.tip)),
                       tag: coordinator.SHOW_HELP,
                       selection: $coordinator.selection){
            EmptyView()
        }.buttonStyle(.plain)
        NavigationLink(destination: SettingsHelpView(),
                       tag: coordinator.SHOW_SETTINGS_HELP,
                       selection: $coordinator.selection){
            EmptyView()
        }.buttonStyle(.plain)
        NavigationLink(destination: SettingsView(),
                       tag: coordinator.SHOW_SETTINGS,
                       selection: $coordinator.selection){
            EmptyView()
        }.buttonStyle(.plain)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
