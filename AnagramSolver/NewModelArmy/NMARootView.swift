//
//  NMARootView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 11/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct NMARootView: View {
    @Environment(AppViewModel.self) var coordinator
    
    @ViewBuilder
    var body: some View {
        NavigationStack(path: Bindable(coordinator).path){
            MainView()
        }
    }
}
