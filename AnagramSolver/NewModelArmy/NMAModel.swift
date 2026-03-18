//
//  NMAModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 18/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

/*
    Data that needs to be shared between various view-models
 */
@Observable
class NMAModel {
    var appState = AppStates.uninitialized
    @ObservationIgnored let engine = WordEngine()
    @ObservationIgnored lazy private(set) var searchHistoryModel =
    {
        SearchHistoryModel(persistence: SearchHistoryUserDefaults(),
                           isSearchHistoryEnabled: Settings().isSearchHistoryEnabled)
    }()

}
