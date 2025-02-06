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
    
    func getHistory() -> [String] {
        let history = Model.sharedInstance
            .searchHistory
            .getHistory()
        if history.count < 5 {
            return []
        }
        return history
            .prefix(upTo: 5)
            .map {$0.trimmingCharacters(in: .whitespaces)}
            .map {"[\($0)](\($0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"}
    }

    private var description : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            ForEach(getHistory(), id: \.self) { historyItem in
                Text(LocalizedStringKey(historyItem))
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
        .environment(\.openURL, OpenURLAction { url in
            if let query = url.absoluteString.removingPercentEncoding{
                coordinator.showHelpExample(example: query)
            }
            return .discarded
        })
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
