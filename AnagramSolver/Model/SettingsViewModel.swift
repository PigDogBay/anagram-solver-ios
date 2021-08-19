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

    @Published var showCardTips = false {
        didSet {
            settings.showCardTips = showCardTips
        }
    }
    
    init(){
        showCardTips = settings.showCardTips
        wordList = settings.wordList
        definition = settings.definition
    }
}
