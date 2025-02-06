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
    @Published var showHistory = true
    
    let historyModel : SearchHistoryModel
    var history : [String]

    init(_ historyModel : SearchHistoryModel){
        self.historyModel = historyModel
        history = historyModel.searchHistory.getHistory()
    }
    
    ///Converts the queries to markdown that the user can tap on
    ///Only takes the first 5 history entries
    var markdownLinks : [String] {
        if history.count < 5 {
            return []
        }
        return history
            .prefix(upTo: 5)
            .map {$0.trimmingCharacters(in: .whitespaces)}
            .map {"[\($0)](\($0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"}
    }

    func clearHistory(){
        historyModel.clearSearchHistory()
        showHistory = false
    }
    
    private func hasHistoryChanged(_ latest : [String]) -> Bool {
        return !( latest.count == history.count
            && latest.count>0
            && latest[0] == history[0] )
    }
    
    func checkShowHistory(_ historyCount : Int){
        let canShow = historyCount > 4
        if canShow != showHistory {
            showHistory = canShow
        }
    }
    
    func onAppear(){
        //Check if need to update the history
        let latest = historyModel
            .searchHistory
            .getHistory()
        checkShowHistory(latest.count)

        if showHistory && hasHistoryChanged(latest){
            //show updated history
            history = latest
            objectWillChange.send()
        }
    }
}
