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

    ///Converts the queries to markdown that the user can tap on
    ///Only takes the first 5 history entries
    var markdownLinks : [String] {
        let history = Model.sharedInstance
            .searchHistory
            .getHistory()
        if history.count < 5 {
            return []
        }
        return history
            .prefix(upTo: 5)
            .map {$0.trimmingCharacters(in: .whitespaces)}
            .map {"[\($0)](\($0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"}
    }

    func clearHistory(){
        showHistory = false
    }
    
    func onAppear(){
        print("VM: Search Card Appears")
    }
}
