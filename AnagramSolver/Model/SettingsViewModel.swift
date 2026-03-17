//
//  SettingsViewModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 19/08/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import Combine
import Observation

@Observable
class SettingsViewModel {
    @ObservationIgnored let settings = Settings()
    
    ///Used to check if the wordListName has changed
    @ObservationIgnored private var originalWordListName = ""

    var wordList : String{
        didSet {
            settings.wordList = wordList
        }
    }

    var definition : String{
        didSet {
            settings.definition = definition
        }
    }
    
    var resultsLimit : String{
        didSet {
            settings.resultsLimitValue = resultsLimit
        }
    }
    
    var highlight : String{
        didSet {
            settings.highlightValue = highlight
        }
    }

    var showCardTips : Bool {
        didSet {
            settings.showCardTips = showCardTips
        }
    }

    var showKeyboard : Bool {
        didSet {
            settings.showKeyboard = showKeyboard
        }
    }
    
    var allowDictation : Bool {
        didSet {
            settings.keyboardType = allowDictation ? Settings.keyboardWebSearch : Settings.keyboardEmail
        }
    }
    
    var isLongPressEnabled : Bool {
        didSet {
            settings.isLongPressEnabled = isLongPressEnabled
        }
    }
    
    var showSubAnagrams : Bool {
        didSet {
            settings.showSubAnagrams = showSubAnagrams
        }
    }
    
    var useMonospacedFont : Bool {
        didSet {
            settings.useMonospacedFont = useMonospacedFont
        }
    }
    
    var useUpperCase : Bool {
        didSet {
            settings.useUpperCase = useUpperCase
        }
    }

    var darkModeOverride : String {
        didSet {
            settings.darkModeOverride = darkModeOverride
            //Update this setting immediately
            Coordinator.sharedInstance.rootVC?.applyDarkModeSetting()
        }
    }

    var spaceToQuestionMark : Bool {
        didSet {
            settings.spaceToQuestionMark = spaceToQuestionMark
        }
    }

    var fullStopToQuestionMark : Bool {
        didSet {
            settings.fullStopToQuestionMark = fullStopToQuestionMark
        }
    }

    var useLargeResultsFont : Bool {
        didSet {
            settings.useLargeResultsFont = useLargeResultsFont
        }
    }

    var isSearchHistoryEnabled : Bool {
        didSet {
            settings.isSearchHistoryEnabled = isSearchHistoryEnabled
        }
    }

    @ObservationIgnored var hasWordListChanged : Bool {
        return originalWordListName != settings.wordList
    }

    init(){
        wordList = settings.wordList
        originalWordListName = settings.wordList
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
        spaceToQuestionMark = settings.spaceToQuestionMark
        fullStopToQuestionMark = settings.fullStopToQuestionMark
        useLargeResultsFont = settings.useLargeResultsFont
        isSearchHistoryEnabled = settings.isSearchHistoryEnabled
    }
 
    func resetToDefaultSettings(){
        wordList = settings.defaultWordList
        definition = settings.defaultDefinition
        resultsLimit = settings.defaultResultsLimit
        highlight = settings.defaultHighlight
        showKeyboard = settings.defaultShowKeyboard
        isLongPressEnabled = settings.defaultLongPressEnabled
        showSubAnagrams = settings.defaultShowSubAnagrams
        showCardTips = settings.defaultShowCardTips
        useMonospacedFont = settings.defaultMonospacedFont
        allowDictation = false
        useUpperCase = settings.defaultUseUppercase
        spaceToQuestionMark = settings.defaultSpaceToQuestionMark
        fullStopToQuestionMark = settings.defaultFullStopToQuestionMark
        darkModeOverride = settings.defaultDarkMode
        useLargeResultsFont = settings.defaultUseLargeResultsFont
        isSearchHistoryEnabled = settings.defaultEnableSearchHistory
    }
}
