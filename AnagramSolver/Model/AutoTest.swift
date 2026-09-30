//
//  NMAAutoTest.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 18/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils


@MainActor
class AutoTest {
    private let model : Model
    private let appVM : AppViewModel
    private let randomQuery = RandomQuery()
    private let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    init(model: Model, appVM: AppViewModel) {
        self.model = model
        self.appVM = appVM
        
        model.onStateChange = { [weak self] newState in
            self?.stateDidChange(newState)
        }
        //Start the first search
        stateDidChange(.ready)
    }
    
    private func stateDidChange(_ newState : AppStates) {
        Task {
            try await update(newState)
        }
    }
    
    private func update(_ newState : AppStates) async throws {
        switch newState {
        case .uninitialized:
            print("AutoTest: uninitialized")
            break
        case .loading:
            print("AutoTest: Loading")
        case .ready:
            print("AutoTest: Ready")
            try await randomQuery()
            self.appVM.search()
        case .searching:
            print("AutoTest: Searching")
            break
        case .finished:
            print("AutoTest: Finished")
            try await Task.sleep(for: .seconds(5))
            self.appVM.goBack()
            self.model.appState = .ready
        case .error:
            print("AutoTest: App Error Detected")
        case .cancelled:
            print("Search stopped")
        }
    }
    
    private func randomQuery() async throws {
        self.appVM.searchBarVM.selection = appVM.searchBarVM.query.mpdbRandomTextSelection()
        self.appVM.searchBarVM.showMe(example: self.randomQuery.query())
        try await Task.sleep(for: .seconds(1))
        self.appVM.searchBarVM.selection = appVM.searchBarVM.query.mpdbRandomTextSelection()
        try await Task.sleep(for: .seconds(1))
        if Bool.random() {
            self.appVM.searchBarVM.insert(symbol: alphabet.randomElement() ?? "?")
            try await Task.sleep(for: .seconds(1))
        }
    }
}
