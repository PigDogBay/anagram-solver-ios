//
//  AppViewModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 10/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUtils
import SwiftUI

enum NavigationScreens : Hashable {
    case Tip(Int)
    case Matches, Definition, Settings, Filters, DefinitionHelp, FiltersHelp, SettingsHelp, About, RemoveAdsDetail
}

@MainActor
@Observable
class AppViewModel {
    @ObservationIgnored let settings = Settings()
    @ObservationIgnored let engine = WordEngine()
    var searchBarVM = SearchBarViewModel()
    
    var query : String {
        return searchBarVM.query
    }
    
    //Navigation stack's path
    var path = NavigationPath()

    ///Called when RootView first appears
    func onLaunch() {
        print("App Launched")
        loadWordList()
    }
    
    ///App life cycle function: called when the app goes into the background
    func onResignActive(){
        engine.stopSearch()
    }
    
    ///Call this when the user presses the Back button
    ///For consistency do not call dismiss() from:
    ///   @Environment(\.dismiss) var dismiss
    func goBack(){
        path.removeLast()
    }
    
    func goto(screen : NavigationScreens){
        path.append(screen)
    }

    private func loadWordList(){
        Task {
            do {
                try await self.engine.loadWordList(name: self.settings.wordList)
            } catch {
                //TO DO Error state
            }
        }
    }

}
