//
//  AutoTest.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 13/10/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils


///From RootViewController.viewDidLoad() call:
///         AutoTest.start(model: self.model, rootVC: self)
/// Remember to edit the Run scheme:
///  - check Debug executable - shows CPU/Memory usuage
///  - Build configuration - select Release so that searches are fast
class AutoTest : AppStateChangeObserver {
    
    private static var instance : AutoTest?
    private let model : Model
    private let randomQuery = RandomQuery()
    private let rootVC : RootViewController
    
    static func start(model : Model, rootVC : RootViewController){
        if instance == nil {
            instance = AutoTest(model: model, rootVC: rootVC)
        }
    }

    init(model : Model, rootVC : RootViewController){
        self.model = model
        self.rootVC = rootVC
        model.appState.addObserver(observer: self)
    }
    
    func search(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            rootVC.textFieldQuery.text = randomQuery.query()
            rootVC.queryFinished(rootVC.textFieldQuery)
        }
    }

    func appStateChanged(_ newState: AppStates) {
        switch newState {
        case .uninitialized:
            break
        case .loading:
            break
        case .ready:
            //Start testing once dictionary has loaded
            search()
        case .searching:
            break
        case .finished:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
                if let navCtrl = rootVC.navigationController {
                    navCtrl.popViewController(animated: true)
                    search()
                }
            }

        }
    }
}
