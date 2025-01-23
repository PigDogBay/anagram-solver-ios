//
//  DefinitionViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 11/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation
import SwiftUtils

class DefinitionViewModel : ObservableObject {
    
    var title = ""
    @Published var definitionItems : [DefinitionItem] = []
    private let dictionary : WordDictionary
    
    init(_ dictionary : WordDictionary){
        self.dictionary = dictionary
        convert(dictionary.lookUpResult)
    }

    private func convert(_ lookUpResult : LookUpResult) {
        self.title = lookUpResult.word
        let converter = LookUpResultToDefinitionItems()
        self.definitionItems = converter.convert(lookUpResult: lookUpResult)
    }

    func createPartOfSpeech(synonymsText : String) -> String {
        if let index = synonymsText.firstIndex(of: " ") {
            return String(synonymsText.prefix(through: index))
        }
        return ""
        
    }
    
    func createMarkdown(synonymsText : String) -> String{
        if let index = synonymsText.firstIndex(of: " ") {
            //chop off part of speech
            return synonymsText
                .suffix(from: index)
                .split(separator: ",")
                .map {$0.trimmingCharacters(in: .whitespaces)}
                .map {"[\($0)](\($0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"}
                .joined(separator: ", ")
        }
        return ""
    }
    
    func synonymTapped(_ url : URL) {
        if let synonym = url.absoluteString.removingPercentEncoding {
            let result = dictionary.lookUpDefinition(synonym)
            if result.isDefinitionAvailable {
                convert(result)
            } else {
                Coordinator.sharedInstance.webLookUp(word: synonym)
            }
        }
    }
    
}

enum DefinitionProviders {
    case Default,Collins, Dictionary, GoogleDictionary, MerriamWebster, MWThesaurus, Thesaurus, Wiktionary, Wikipedia, WordGameDictionary
}

struct DefaultDefintion{
    let word : String
    
    func lookupUrl() -> String? {
        let settings = Settings()
        return settings.getDefinitionUrl(word: word)
    }
}

struct ContextDefintion {
    let word : String
    let provider : DefinitionProviders
    
    func lookupUrl() -> String? {
        let lookup = LookUpUrl(word: word)
        switch provider {
        case .Default:
            return lookup.googleDefine
        case .Collins:
            return lookup.collins
        case .Dictionary:
            return lookup.dictionaryCom
        case .GoogleDictionary:
            return lookup.googleDictionary
        case .MerriamWebster:
            return lookup.merriamWebster
        case .MWThesaurus:
            return lookup.merriamWebsterThesaurus
        case .Thesaurus:
            return lookup.thesaurusCom
        case .Wiktionary:
            return lookup.wikionary
        case .Wikipedia:
            return lookup.wikipedia
        case .WordGameDictionary:
            return lookup.wordGameDictionary
        }
    }
}

