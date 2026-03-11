//
//  AppViewModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 10/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUtils
import SwiftUI

enum NavigationScreens : Hashable {
    case Tip(Int)
    case Definition, Settings, Filters, DefinitionHelp, FiltersHelp, SettingsHelp, About, RemoveAdsDetail
}

@MainActor
@Observable
class AppViewModel {
    @ObservationIgnored let settings = Settings()

    var searchBarVM = SearchBarViewModel()
    
    //Navigation stack's path
    var path = NavigationPath()

    
    ///App life cycle function: called when the app goes into the background
    func onResignActive(){
//        model.stopSearch()
    }
    
    ///Call this when the user presses the Back button
    ///For consistency do not call dismiss() from:
    ///   @Environment(\.dismiss) var dismiss
    func goBack(){
        path.removeLast()
    }
    
    func goto(screen : NavigationScreens){
        path.append(screen)
    }


}
