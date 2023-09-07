//
//  Settings.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 16/01/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

class Settings
{
    static let wordListTitles = [
        "Essential (90k words)",
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

    private let definitionKey = "definition"
    private let highlightKey = "highlight"
    private let showKeyboardKey = "showKeyboard"
    private let longPressEnabledKey = "longPressEnabled"
    private let useMonospacedFontKey = "useMonospacedFont"
    private let wordListKey = "wordList"
    private let showSubAnagramsKey = "showSubAnagrams"
    private let resultsLimitKey = "resultsLimit"
    private let isProKey = "isProFlag"
    private let useNonPersonalizedAdsKey = "useNonPersonalisedAds"
    private let showCardTipsKey = "showCardTips"
    private let darkModeOverrideKey = "darkModeOverride"
    private let keyboardTypeKey = "keyboardType"
    private let useUpperCaseKey = "useUpperCase"
    private let fullStopToQuestionMarkKey = "fullStopToQuestionMark"
    private let spaceToQuestionMarkKey = "spaceToQuestionMark"
    private let useLargeResultsFontKey = "useLargeResultsFont"

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

    var highlight : UIColor {
        get {
            if let colorString = UserDefaults.standard.string(forKey: highlightKey){
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
        get { return UserDefaults.standard.string(forKey: keyboardTypeKey) ?? defaultKeyboardType}
        set(value) {
            if value != keyboardType {
                let defaults = UserDefaults.standard
                defaults.set(value, forKey: keyboardTypeKey)
            }
        }
    }

    var highlightValue : String {
        get { return UserDefaults.standard.string(forKey: highlightKey) ?? defaultHighlight}
        set(value) {
            if value != highlightValue {
                let defaults = UserDefaults.standard
                defaults.set(value, forKey: highlightKey)
            }
        }
    }

    var useMonospacedFont : Bool {
        get {
            return UserDefaults.standard.bool(forKey: useMonospacedFontKey)
        }
        set(flag) {
            if flag != useMonospacedFont {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: useMonospacedFontKey)
            }
        }
    }
    
    var showKeyboard : Bool {
        get {
            return UserDefaults.standard.bool(forKey: showKeyboardKey)
        }
        set(flag) {
            if flag != showKeyboard {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: showKeyboardKey)
            }
        }
    }

    var spaceToQuestionMark : Bool {
        get {
            return UserDefaults.standard.bool(forKey: spaceToQuestionMarkKey)
        }
        set(flag) {
            if flag != spaceToQuestionMark {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: spaceToQuestionMarkKey)
            }
        }
    }

    var fullStopToQuestionMark : Bool {
        get {
            return UserDefaults.standard.bool(forKey: fullStopToQuestionMarkKey)
        }
        set(flag) {
            if flag != fullStopToQuestionMark {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: fullStopToQuestionMarkKey)
            }
        }
    }

    var isLongPressEnabled : Bool {
        get {
            return UserDefaults.standard.bool(forKey: longPressEnabledKey)
        }
        set(flag) {
            if flag != isLongPressEnabled {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: longPressEnabledKey)
            }
        }
    }
    
    var isProMode : Bool{
        get{
            return UserDefaults.standard.bool(forKey: isProKey)
        }
        set(flag) {
            let defaults = UserDefaults.standard
            defaults.set(flag, forKey: isProKey)
        }
    }
    
    func getDefinitionUrl(word : String) -> String {
        let lookup = LookUpUrl(word: word)
        if let website = UserDefaults.standard.string(forKey: definitionKey) {
            return lookup.findUrl(fromSetting: website)
        }
        return lookup.googleDefine
    }

    var definition : String {
        get { return UserDefaults.standard.string(forKey: definitionKey) ?? defaultDefinition}
        set(value) {
            if value != definition {
                let defaults = UserDefaults.standard
                defaults.set(value, forKey: definitionKey)
            }
        }
    }

    var resultsLimit : Int {
        get {
            return UserDefaults.standard.integer(forKey: resultsLimitKey)
        }
    }

    var resultsLimitValue : String {
        get { return UserDefaults.standard.string(forKey: resultsLimitKey) ?? defaultResultsLimit}
        set(value) {
            if value != resultsLimitValue {
                let defaults = UserDefaults.standard
                defaults.set(value, forKey: resultsLimitKey)
            }
        }
    }

    
    var wordList : String {
        get { return UserDefaults.standard.string(forKey: wordListKey) ?? defaultWordList}
        set(newList) {
            if newList != wordList {
                let defaults = UserDefaults.standard
                defaults.set(newList, forKey: wordListKey)
            }
        }
    }
    
    var showSubAnagrams : Bool {
        get {
            return UserDefaults.standard.bool(forKey: showSubAnagramsKey)
        }
        set(flag) {
            if flag != showSubAnagrams {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: showSubAnagramsKey)
            }
        }
    }
    
    var showCardTips : Bool {
        get {
            return UserDefaults.standard.bool(forKey: showCardTipsKey)
        }
        set(flag) {
            if flag != showCardTips {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: showCardTipsKey)
            }
        }
    }
    
    var useNonPersonalizedAds : Bool {
        get{
            return UserDefaults.standard.bool(forKey: useNonPersonalizedAdsKey)
        }
        set(flag) {
            if flag != useNonPersonalizedAds {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: useNonPersonalizedAdsKey)
            }
        }
    }

    var darkModeOverride : String {
        get {
            return UserDefaults.standard.string(forKey: darkModeOverrideKey) ?? defaultDarkMode
        }
        set(value){
            if value != darkModeOverride {
                UserDefaults.standard.set(value, forKey: darkModeOverrideKey)
            }
        }
    }

    var useUpperCase : Bool {
        get {
            return UserDefaults.standard.bool(forKey: useUpperCaseKey)
        }
        set(flag) {
            if flag != useUpperCase {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: useUpperCaseKey)
            }
        }
    }
    
    var useLargeResultsFont : Bool {
        get {
            return UserDefaults.standard.bool(forKey: useLargeResultsFontKey)
        }
        set(flag) {
            if flag != useLargeResultsFont {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: useLargeResultsFontKey)
            }
        }
    }

    func registerDefaultSettings() {
        let defaultSettings : [ String : Any] = [definitionKey : defaultDefinition,
                                                  highlightKey : defaultHighlight,
                                               showKeyboardKey : defaultShowKeyboard,
                                           longPressEnabledKey : defaultLongPressEnabled,
                                                   wordListKey : defaultWordList,
                                                      isProKey : false,
                                            showSubAnagramsKey : defaultShowSubAnagrams,
                                               showCardTipsKey : defaultShowCardTips,
                                               resultsLimitKey : 5000,
                                               keyboardTypeKey : defaultKeyboardType,
                                        spaceToQuestionMarkKey : defaultSpaceToQuestionMark,
                                     fullStopToQuestionMarkKey : defaultFullStopToQuestionMark,
                                            darkModeOverrideKey: defaultDarkMode,
                                               useUpperCaseKey : defaultUseUppercase,
                                          useMonospacedFontKey : defaultMonospacedFont,
                                        useLargeResultsFontKey : defaultUseLargeResultsFont,
                                      useNonPersonalizedAdsKey : false]
        UserDefaults.standard.register(defaults: defaultSettings)
    }
}
