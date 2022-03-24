//
//  SettingsViewModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 19/08/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import Combine

class SettingsViewModel : ObservableObject {
    let settings = Settings()
    
    @Published var wordList : String{
        didSet {
            settings.wordList = wordList
        }
    }

    @Published var definition : String{
        didSet {
            settings.definition = definition
        }
    }
    
    @Published var resultsLimit : String{
        didSet {
            settings.resultsLimitValue = resultsLimit
        }
    }
    
    @Published var highlight : String{
        didSet {
            settings.highlightValue = highlight
        }
    }

    @Published var showCardTips : Bool {
        didSet {
            settings.showCardTips = showCardTips
        }
    }

    @Published var showKeyboard : Bool {
        didSet {
            settings.showKeyboard = showKeyboard
        }
    }
    
    @Published var allowDictation : Bool {
        didSet {
            settings.keyboardType = allowDictation ? Settings.keyboardWebSearch : Settings.keyboardEmail
        }
    }
    
    @Published var isLongPressEnabled : Bool {
        didSet {
            settings.isLongPressEnabled = isLongPressEnabled
        }
    }
    
    @Published var showSubAnagrams : Bool {
        didSet {
            settings.showSubAnagrams = showSubAnagrams
        }
    }
    
    @Published var useMonospacedFont : Bool {
        didSet {
            settings.useMonospacedFont = useMonospacedFont
        }
    }
    
    @Published var useUpperCase : Bool {
        didSet {
            settings.useUpperCase = useUpperCase
        }
    }

    @Published var darkModeOverride : String {
        didSet {
            settings.darkModeOverride = darkModeOverride
            //Update this setting immediately
            Coordinator.sharedInstance.rootVC?.applyDarkModeSetting()
        }
    }
    
    init(){
        wordList = settings.wordList
        definition = settings.definition
        resultsLimit = settings.resultsLimitValue
        highlight = settings.highlightValue
        showKeyboard = settings.showKeyboard
        isLongPressEnabled = settings.isLongPressEnabled
        showSubAnagrams = settings.showSubAnagrams
        showCardTips = settings.showCardTips
        useMonospacedFont = settings.useMonospacedFont
        darkModeOverride = settings.darkModeOverride
        allowDictation = settings.keyboardType == Settings.keyboardWebSearch
        useUpperCase = settings.useUpperCase
    }
 
    func resetToDefaultSettings(){
    }
}
