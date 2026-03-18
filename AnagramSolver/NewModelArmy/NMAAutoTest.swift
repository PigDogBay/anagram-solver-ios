//
//  NMAAutoTest.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 18/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import Foundation
import Combine
import SwiftUtils

@MainActor
class NMAAutoTest {
    private let model : NMAModel
    private let appVM : AppViewModel
    private var disposables = Set<AnyCancellable>()
    private let randomQuery = RandomQuery()
    
    init(model: NMAModel, appVM: AppViewModel) {
        self.model = model
        self.appVM = appVM

        model.$appState
            .sink(receiveValue:{[weak self] appState in self?.onAppState(newState: appState)})
            .store(in: &disposables)

    }
    
    private func onAppState(newState : AppStates){
        switch newState {
        case .uninitialized:
            print("AutoTest: uninitialized")
            break
        case .loading:
            print("AutoTest: Loading")
        case .ready:
            print("AutoTest: Ready")
            Task {
                self.appVM.searchBarVM.query = self.randomQuery.query()
                try await Task.sleep(for: .seconds(2))
                self.appVM.search()
            }
        case .searching:
            print("AutoTest: Searching")
            break
        case .finished:
            print("AutoTest: Finished")
            Task {
                try await Task.sleep(for: .seconds(5))
                self.appVM.goBack()
                self.model.appState = .ready
            }
        case .error:
            print("AutoTest: App Error Detected")
        }
        
    }
}
