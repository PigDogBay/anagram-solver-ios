//
//  HomeView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 22/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var coordinator : Coordinator
    var body: some View {
        if coordinator.showCards {
            CardTips(coordinator: coordinator)
        } else {
            TipsView(coordinator: coordinator)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(coordinator: Coordinator())
    }
}
