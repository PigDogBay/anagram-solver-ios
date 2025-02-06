//
//  SearchHistoryView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 06/02/2025.
//  Copyright © 2025 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct SearchHistoryView: View {
    private let coordinator = Coordinator.sharedInstance
    private let history = Model.sharedInstance
        .searchHistoryModel
        .searchHistory
        .getHistory()

    private let columns = [GridItem(.adaptive(minimum: 350))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(history, id: \.self) { historyItem in
                    Text(historyItem)
                }
            }
        }
    }
}
