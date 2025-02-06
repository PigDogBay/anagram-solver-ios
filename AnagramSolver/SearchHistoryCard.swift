//
//  SearchHistoryCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 06/02/2025.
//  Copyright © 2025 MPD Bailey Technology. All rights reserved.
//

import SwiftUI
import SwiftUtils

struct SearchHistoryCard: View {
    private let coordinator = Coordinator.sharedInstance
    
    private let history = Model.sharedInstance
        .searchHistory
        .getHistory()
        .prefix(upTo: 5)

    private var description : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            ForEach(history, id: \.self) { historyItem in
                Text(historyItem)
            }
        }
    }

    private var buttons : some View {
        HStack(){
            Button(action:{coordinator.clearHistory()}){
                Text("CLEAR")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action: {coordinator.show(coordinator.SHOW_SEARCH_HISTORY)}){
                Text("SHOW ALL")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            CardTitle(title: "History", icon: "history")
                .padding(.top,16)
            description
                .padding(.top,2)
            buttons
                .padding(16)
        }
    }
}

struct SearchHistoryCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchHistoryCard()
            SearchHistoryCard()
                .preferredColorScheme(.dark)
            
        }.previewLayout(.fixed(width: 300, height: 220))
    }
}
