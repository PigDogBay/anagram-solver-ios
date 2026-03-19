//
//  NMAModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 18/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils


enum AppStates
{
    case uninitialized, loading, ready, searching, finished, error
}

/*
    Data that needs to be shared between various view-models
 */
@Observable
class Model {
    var appState: AppStates = .uninitialized {
        //AppState needs to be tracked by AutoTest
        didSet { onStateChange?(appState) }
    }
    @ObservationIgnored var onStateChange: ((AppStates) -> Void)?

    @ObservationIgnored let engine = WordEngine()
    @ObservationIgnored lazy private(set) var searchHistoryModel =
    {
        SearchHistoryModel(persistence: SearchHistoryUserDefaults(),
                           isSearchHistoryEnabled: Settings().isSearchHistoryEnabled)
    }()
}
