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
    let showHistory : Bool
    let historyModel : SearchHistoryModel

    init(_ historyModel : SearchHistoryModel){
        self.historyModel = historyModel
        self.showHistory = historyModel.canShowSearchHistory
    }
    
    func clearHistory(){
        historyModel.clearSearchHistory()
        //Update UI
        objectWillChange.send()
    }
    
    ///If navigating back from the matches view controller, the view will not be recreated
    ///so need to Check if need to update the history
    func onAppear(){
        if historyModel.hasHistoryChanged(){
            objectWillChange.send()
        }
    }
}
