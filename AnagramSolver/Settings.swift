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
    fileprivate let definitionKey = "definition"
    fileprivate let highlightKey = "highlight"
    fileprivate let showKeyboardKey = "showKeyboard"
    fileprivate let longPressEnabledKey = "longPressEnabled"
    fileprivate let useMonospacedFontKey = "useMonospacedFont"
    fileprivate let useProWordListKey = "useProWordList"
    fileprivate let showSubAnagramsKey = "showSubAnagrams"
    fileprivate let resultsLimitKey = "resultsLimit"
    fileprivate let isProKey = "isProFlag"
    
    let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
    
    var highlight : UIColor {
        get {
            if let colorString = UserDefaults.standard.string(forKey: highlightKey){
                switch colorString {
                case "black":
                    return UIColor.black
                case "blue":
                    return UIColor.blue
                case "green":
                    return self.darkGreen
                default:
                    break
                }
            }
            return UIColor.red
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
            defaults.synchronize()
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
    
    var resultsLimit : Int {
        get {
            return UserDefaults.standard.integer(forKey: resultsLimitKey)
        }
    }
    
    var useProWordList : Bool {
        get {
            return UserDefaults.standard.bool(forKey: useProWordListKey)
        }
    }
    
    var showSubAnagrams : Bool {
        get {
            return UserDefaults.standard.bool(forKey: showSubAnagramsKey)
        }
    }

    func registerDefaultSettings() {
        let defaultSettings : [ String : Any] = [definitionKey : "google",
                               highlightKey : "red",
                               showKeyboardKey : false,
                               longPressEnabledKey : true,
                               useProWordListKey : true,
                               isProKey : false,
                               showSubAnagramsKey : true,
                               resultsLimitKey : 5000]
        UserDefaults.standard.register(defaults: defaultSettings)
    }
}
