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
    case Tip(Tip)
    case Matches, Definition, Settings, Filters, DefinitionHelp, FiltersHelp, SettingsHelp, About, RemoveAdsDetail, SearchHistory
}

@MainActor
@Observable
class AppViewModel {
    var appState = AppStates.uninitialized
    let searchBarVM = SearchBarViewModel()

    @ObservationIgnored let settings = Settings()
    @ObservationIgnored let engine = WordEngine()
    @ObservationIgnored let ads = Ads()
    @ObservationIgnored lazy private(set) var searchHistoryModel =
    {
        SearchHistoryModel(persistence: SearchHistoryUserDefaults(),
                           isSearchHistoryEnabled: self.settings.isSearchHistoryEnabled)
    }()

    
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
    
    func search(){
        if appState == .ready {
            goto(screen: .Matches)
        }
    }
    
    func matchesExited(){
        engine.stopSearch()
        goBack()
    }
    
    func settingsExited(didChangeWordList : Bool){
        engine.resultsLimit = settings.resultsLimit
        engine.wordSearch.findSubAnagrams = settings.showSubAnagrams
        if didChangeWordList {
            loadWordList()
        }
        goBack()
    }

    func show(_ tip : Tip){
        path.append(NavigationScreens.Tip(tip))
    }
    
    func showMe(example : String) {
        searchBarVM.showMe(example: example)
        path.append(NavigationScreens.Matches)
    }
    
    func webLookUp(word : String) {
        let defModel = DefaultDefintion(word: word)
        if let url = defModel.lookupUrl(){
            showWebPage(address: url)
        }
    }

    func lookUpWord(word : String){
        let lookUpResult = engine.lookUpDefinition(word)
        if (lookUpResult.isDefinitionAvailable) {
            goto(screen: .Definition)
        } else {
            //No definition found, so open a web browser to search for it
            webLookUp(word: word)
        }
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
