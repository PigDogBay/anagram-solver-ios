//
//  Settings.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 16/01/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

enum Keys {
    static let definition = "definition"
    static let highlight = "highlight"
    static let showKeyboard = "showKeyboard"
    static let longPressEnabled = "longPressEnabled"
    static let useMonospacedFont = "useMonospacedFont"
    static let wordList = "wordList"
    static let showSubAnagrams = "showSubAnagrams"
    static let resultsLimit = "resultsLimit"
    static let isPro = "isProFlag"
    static let showCardTips = "showCardTips"
    static let darkModeOverride = "darkModeOverride"
    static let keyboardType = "keyboardType"
    static let useUpperCase = "useUpperCase"
    static let fullStopToQuestionMark = "fullStopToQuestionMark"
    static let spaceToQuestionMark = "spaceToQuestionMark"
    static let useLargeResultsFont = "useLargeResultsFont"
    static let enableSearchHistory = "enableSearchHistory"
}

class Settings
{
    static let wordListTitles = [
        "Essential (90k words)",
        "Game Acceptable (82k words)",
        "US Scrabble (180k words)",
        "World Scrabble (270k words)",
        "English (310k words)",
        "Deutsch (198k wörter)",
        "Español (381k palabras)",
        "Français (268k mots)",
        "Italiano (250k parole)",
        "Português (210k palavras)"]
    
    static let wordListValues = [
        "small",
        "game",
        "twl",
        "sowpods",
        "words",
        "wordlist-de",
        "wordlist-es",
        "wordlist-fr",
        "wordlist-it",
        "wordlist-pt"]
    
    static let definitionTitles = [
        "Cambridge",
        "Chambers",
        "Collins",
        "Dictionary.com",
        "Google Define",
        "Google Dictionary",
        "Merriam-Webster",
        "Merriam-Webster Thesaurus",
        "Thesaurus.com",
        "Wiktionary",
        "Wikipedia",
        "Word Game Dictionary"]

    static let definitionValues = [
        "cambridge",
        "chambers",
        "collins",
        "dictionary.com",
        "google define",
        "google",
        "merriam-webster",
        "merriam-webster thesaurus",
        "thesaurus.com",
        "wiktionary",
        "wikipedia",
        "word game dictionary"]
    
    static let resultsLimitTitles = [
        "100 words",
        "500 words",
        "1000 words",
        "5000 words"]

    static let resultsLimitValues = [
        "100",
        "500",
        "1000",
        "5000"]
    
    static let highlightTitles = [
        "None",
        "Red",
        "Green",
        "Blue",
        "Yellow"]

    static let highlightValues = [
        "black",
        "red",
        "green",
        "blue",
        "yellow"]

    static let darkModeTitles = [
        "System",
        "Dark",
        "Light"]
    
    static let darkModeValueSystem = "system"
    static let darkModeValueDark = "dark"
    static let darkModeValueLight = "light"
    static let darkModeValues = [
        darkModeValueSystem,
        darkModeValueDark,
        darkModeValueLight]
    
    static let keyboardEmail = "email"
    static let keyboardWebSearch = "webSearch"

    let defaultWordList = "words"
    let defaultDefinition = "google define"
    let defaultResultsLimit = "5000"
    let defaultHighlight = "red"
    let defaultDarkMode = darkModeValueSystem
    let defaultKeyboardType = keyboardEmail
    let defaultShowKeyboard = false
    let defaultLongPressEnabled = true
    let defaultShowSubAnagrams = true
    let defaultShowCardTips = true
    let defaultUseUppercase = false
    let defaultMonospacedFont = false
    let defaultFullStopToQuestionMark = false
    let defaultSpaceToQuestionMark = false
    let defaultUseLargeResultsFont = false
    let defaultEnableSearchHistory = true

    var highlight : UIColor {
        get {
            if let colorString = UserDefaults.standard.string(forKey: Keys.highlight){
                switch colorString {
                case "black":
                    return UIColor.label
                case "blue":
                    return UIColor(named: "exampleQuery") ?? UIColor.systemBlue
                case "green":
                    return UIColor(named: "highlightGreen") ?? UIColor.systemGreen
                case "yellow":
                    return UIColor(named: "highlightYellow") ?? UIColor.systemYellow
                default:
                    break
                }
            }
            return UIColor(named: "exampleResult") ?? UIColor.systemRed
        }
    }
    
    var keyboardType : String {
        get { return UserDefaults.standard.string(forKey: Keys.keyboardType) ?? defaultKeyboardType}
        set(value) {
            if value != keyboardType {
                let defaults = UserDefaults.standard
                defaults.set(value, forKey: Keys.keyboardType)
            }
        }
    }

    var highlightValue : String {
        get { return UserDefaults.standard.string(forKey: Keys.highlight) ?? defaultHighlight}
        set(value) {
            if value != highlightValue {
                let defaults = UserDefaults.standard
                defaults.set(value, forKey: Keys.highlight)
            }
        }
    }

    var useMonospacedFont : Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.useMonospacedFont)
        }
        set(flag) {
            if flag != useMonospacedFont {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: Keys.useMonospacedFont)
            }
        }
    }
    
    var showKeyboard : Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.showKeyboard)
        }
        set(flag) {
            if flag != showKeyboard {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: Keys.showKeyboard)
            }
        }
    }

    var spaceToQuestionMark : Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.spaceToQuestionMark)
        }
        set(flag) {
            if flag != spaceToQuestionMark {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: Keys.spaceToQuestionMark)
            }
        }
    }

    var fullStopToQuestionMark : Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.fullStopToQuestionMark)
        }
        set(flag) {
            if flag != fullStopToQuestionMark {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: Keys.fullStopToQuestionMark)
            }
        }
    }

    var isLongPressEnabled : Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.longPressEnabled)
        }
        set(flag) {
            if flag != isLongPressEnabled {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: Keys.longPressEnabled)
            }
        }
    }
    
    var isProMode : Bool{
        get{
            return UserDefaults.standard.bool(forKey: Keys.isPro)
        }
        set(flag) {
            let defaults = UserDefaults.standard
            defaults.set(flag, forKey: Keys.isPro)
        }
    }
    
    func getDefinitionUrl(word : String) -> String {
        let lookup = LookUpUrl(word: word)
        if let website = UserDefaults.standard.string(forKey: Keys.definition) {
            return lookup.findUrl(fromSetting: website)
        }
        return lookup.googleDefine
    }

    var definition : String {
        get { return UserDefaults.standard.string(forKey: Keys.definition) ?? defaultDefinition}
        set(value) {
            if value != definition {
                let defaults = UserDefaults.standard
                defaults.set(value, forKey: Keys.definition)
            }
        }
    }

    var resultsLimit : Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.resultsLimit)
        }
    }

    var resultsLimitValue : String {
        get { return UserDefaults.standard.string(forKey: Keys.resultsLimit) ?? defaultResultsLimit}
        set(value) {
            if value != resultsLimitValue {
                let defaults = UserDefaults.standard
                defaults.set(value, forKey: Keys.resultsLimit)
            }
        }
    }

    
    var wordList : String {
        get { return UserDefaults.standard.string(forKey: Keys.wordList) ?? defaultWordList}
        set(newList) {
            if newList != wordList {
                let defaults = UserDefaults.standard
                defaults.set(newList, forKey: Keys.wordList)
            }
        }
    }
    
    var showSubAnagrams : Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.showSubAnagrams)
        }
        set(flag) {
            if flag != showSubAnagrams {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: Keys.showSubAnagrams)
            }
        }
    }
    
    var showCardTips : Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.showCardTips)
        }
        set(flag) {
            if flag != showCardTips {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: Keys.showCardTips)
            }
        }
    }

    var darkModeOverride : String {
        get {
            return UserDefaults.standard.string(forKey: Keys.darkModeOverride) ?? defaultDarkMode
        }
        set(value){
            if value != darkModeOverride {
                UserDefaults.standard.set(value, forKey: Keys.darkModeOverride)
            }
        }
    }

    var useUpperCase : Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.useUpperCase)
        }
        set(flag) {
            if flag != useUpperCase {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: Keys.useUpperCase)
            }
        }
    }
    
    var useLargeResultsFont : Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.useLargeResultsFont)
        }
        set(flag) {
            if flag != useLargeResultsFont {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: Keys.useLargeResultsFont)
            }
        }
    }

    var isSearchHistoryEnabled : Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.enableSearchHistory)
        }
        set(flag) {
            if flag != isSearchHistoryEnabled {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: Keys.enableSearchHistory)
            }
        }
    }
    
    func registerDefaultSettings() {
        let defaultSettings : [ String : Any] = [Keys.definition : defaultDefinition,
                                                 Keys.highlight : defaultHighlight,
                                                 Keys.showKeyboard : defaultShowKeyboard,
                                                 Keys.longPressEnabled : defaultLongPressEnabled,
                                                 Keys.wordList : defaultWordList,
                                                 Keys.isPro : false,
                                                 Keys.showSubAnagrams : defaultShowSubAnagrams,
                                                 Keys.showCardTips : defaultShowCardTips,
                                                 Keys.resultsLimit : 5000,
                                                 Keys.keyboardType : defaultKeyboardType,
                                                 Keys.spaceToQuestionMark : defaultSpaceToQuestionMark,
                                                 Keys.fullStopToQuestionMark : defaultFullStopToQuestionMark,
                                                 Keys.darkModeOverride: defaultDarkMode,
                                                 Keys.useUpperCase : defaultUseUppercase,
                                                 Keys.useMonospacedFont : defaultMonospacedFont,
                                                 Keys.useLargeResultsFont : defaultUseLargeResultsFont,
                                                 Keys.enableSearchHistory: defaultEnableSearchHistory,
                                      ]
        UserDefaults.standard.register(defaults: defaultSettings)
    }
}
