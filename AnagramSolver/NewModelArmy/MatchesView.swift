//
//  MatchesView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 12/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct MatchesView: View {
    @Environment(AppViewModel.self) var appViewModel
    @State var matchesVM : MatchesViewModel

    var body: some View {
        Text("Query \(matchesVM.query)")
            .navigationTitle("\(matchesVM.query)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarIconButton(placement: .topBarLeading, iconName: "chevron.left") {appViewModel.goBack()}
                ToolbarButton(placement: .topBarTrailing, label: "Filters"){appViewModel.goto(screen: .Filters)}
            }
    }
}

#Preview {
    MatchesView(matchesVM: MatchesViewModel(query: "preview", engine: WordEngine()))
}
