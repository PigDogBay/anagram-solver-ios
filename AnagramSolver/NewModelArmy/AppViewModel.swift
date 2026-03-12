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
    var appState = AppStates.uninitialized

    var query : String {
        return searchBarVM.query
    }
    
    var showErrorAlert : Binding<Bool> {
        Binding(
            get: {
                self.appState == .error
            },
            set: {
                if !$0{
                    print("Error Detected!")
                    self.appState = .uninitialized
                    //Just incase reset to the default wordlist
                    self.settings.wordList = self.settings.defaultWordList
                    self.loadWordList()
                }
            }
        )
    }
    
    //Navigation stack's path
    var path = NavigationPath()

    ///Called when RootView first appears
    func onLaunch() {
        if (appState == .uninitialized){
            loadWordList()
        }
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
        appState = .loading
        Task {
            do {
                try await self.engine.loadWordList(name: self.settings.wordList)
                appState = .ready
            } catch {
                appState = .error
            }
        }
    }

}
