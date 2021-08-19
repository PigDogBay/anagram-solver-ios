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
        "Lexico",
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
        "lexico",
        "merriam-webster",
        "merriam-webster thesaurus",
        "thesaurus.com",
        "wiktionary",
        "wikipedia",
        "word game dictionary"]


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
    
    private let defaultWordList = "words"
    private let defaultDefinition = "google"

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

    var useMonospacedFont : Bool {
        get {
            return UserDefaults.standard.bool(forKey: useMonospacedFontKey)
        }
    }
    
    var showKeyboard : Bool {
        get {
            return UserDefaults.standard.bool(forKey: showKeyboardKey)
        }
    }
    
    var isLongPressEnabled : Bool {
        get {
            return UserDefaults.standard.bool(forKey: longPressEnabledKey)
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
        if let website = UserDefaults.standard.string(forKey: definitionKey) {
            switch website {
                case "cambridge":
                    return WordSearch.getCambridgeUrl(word: word)
                case "chambers":
                    return WordSearch.getChambersUrl(word: word)
                case "collins":
                    return WordSearch.getCollinsUrl(word: word)
                case "dictionary.com":
                    return WordSearch.getDictionaryComUrl(word: word)
                case "google define":
                    return WordSearch.getGoogleDefineUrl(word: word)
                case "google":
                    return WordSearch.getGoogleUrl(word: word)
                case "lexico":
                    return WordSearch.getLexicoUrl(word: word)
                case "merriam-webster":
                    return WordSearch.getMerriamWebsterUrl(word: word)
                case "merriam-webster thesaurus":
                    return WordSearch.getMWThesaurusUrl(word: word)
                case "thesaurus.com":
                    return WordSearch.getThesaurusComUrl(word: word)
                case "wiktionary":
                    return WordSearch.getWiktionaryUrl(word: word)
                case "wikipedia":
                    return WordSearch.getWikipediaUrl(word: word)
                case "word game dictionary":
                    return WordSearch.getWordGameDictionaryUrl(word: word)
            default:
                break
            }
        }
        return WordSearch.getGoogleUrl(word: word)
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

    func registerDefaultSettings() {
        let defaultSettings : [ String : Any] = [definitionKey : "google define",
                               highlightKey : "red",
                               showKeyboardKey : false,
                               longPressEnabledKey : true,
                               wordListKey : defaultWordList,
                               isProKey : false,
                               showSubAnagramsKey : true,
                               showCardTipsKey : true,
                               resultsLimitKey : 5000,
                               useNonPersonalizedAdsKey : false]
        UserDefaults.standard.register(defaults: defaultSettings)
    }
}
