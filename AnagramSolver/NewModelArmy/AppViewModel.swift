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
    var appState = AppStates.uninitialized
    @ObservationIgnored let ads = Ads()
    
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
    
    func webLookUp(word : String) {
        let defModel = DefaultDefintion(word: word)
        if let url = defModel.lookupUrl(){
            showWebPage(address: url)
        }
    }

    func lookUpWord(word : String){
        webLookUp(word: word)
//        let lookUpResult = model.lookUpDefinition(word)
//        if (lookUpResult.isDefinitionAvailable) {
//            //Navigate to the DefinitionView
//            path.append(NavigationScreens.Definition)
//        } else {
//            //No definition found, so open a web browser to search for it
//            webLookUp(word: word)
//        }
    }
    
    func lookUpWord(word : String, provider : DefinitionProviders){
        let defModel = ContextDefintion(word : word, provider: provider)
        if let url = defModel.lookupUrl(){
            showWebPage(address: url)
        }
    }

    func showWebPage(address : String) {
        if let url = URL(string: address) {
            UIApplication.shared.open(url, options: [:])
        }
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
