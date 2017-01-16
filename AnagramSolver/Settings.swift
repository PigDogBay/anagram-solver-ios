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
    let definitionKey = "definition"
    let highlightKey = "highlight"
    let showKeyboardKey = "showKeyboard"
    let longPressEnabledKey = "longPressEnabled"
    let useProWordListKey = "useProWordList"
    let resultsLimitKey = "resultsLimit"
    let darkGreen = UIColor(colorLiteralRed: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
    
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
    
    func getDefinitionUrl(word : String) -> String {
        if let website = UserDefaults.standard.string(forKey: definitionKey) {
            switch website {
            case "merriam-webster":
                return WordSearch.getMerriamWebsterUrl(word: word)
            case "thesaurus":
                return WordSearch.getThesaurusUrl(word: word)
            case "collins":
                return WordSearch.getCollinsUrl(word: word)
            case "oxford":
                return WordSearch.getOxfordDictionariesUrl(word: word)
            case "wikipedia":
                return WordSearch.getWikipediaUrl(word: word)
            default:
                break
            }
        }
        return WordSearch.getGoogleUrl(word: word)
    }
    
    func registerDefaultSettings() {
        let defaultSettings : [ String : Any] = [definitionKey : "google",
                               highlightKey : "red",
                               showKeyboardKey : false,
                               longPressEnabledKey : true,
                               useProWordListKey : true,
                               resultsLimitKey : 500]
        UserDefaults.standard.register(defaults: defaultSettings)
    }
    
}
