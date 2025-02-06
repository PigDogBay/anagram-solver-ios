//
//  SearchHistoryCardViewModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 06/02/2025.
//  Copyright © 2025 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

class SearchHistoryCardViewModel : ObservableObject {
    @Published var showHistory : Bool
    
    let historyModel : SearchHistoryModel

    init(_ historyModel : SearchHistoryModel){
        self.historyModel = historyModel
        self.showHistory = historyModel.canShowSearchHistory
    }
    
    func clearHistory(){
        historyModel.clearSearchHistory()
        showHistory = false
    }
    
    func onAppear(){
        //Sync with model, but only set if different ( to
        //prevent unnecessary change notifications)
        if historyModel.canShowSearchHistory != showHistory {
            showHistory = historyModel.canShowSearchHistory
        }

        //Check if need to update the history
        if showHistory && historyModel.hasHistoryChanged(){
            objectWillChange.send()
        }
    }
}
