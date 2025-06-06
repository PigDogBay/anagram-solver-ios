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
    @ObservedObject var viewModel : SearchHistoryCardViewModel

    private var historyLinks : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            ForEach(viewModel.historyModel.markdownLinks, id: \.self) { historyItem in
                Text(LocalizedStringKey(historyItem))
            }
        }
    }
    private var noHistory : some View {
        Text("Lists your previous searches")
    }

    private var buttons : some View {
        HStack(){
            Button(action:{viewModel.clearHistory()}){
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
            if viewModel.isHistoryAvailable {
                historyLinks
                    .padding(.top,2)
                buttons
                    .padding(16)
            } else {
                noHistory
                    .font(.body.italic())
                    .padding(.bottom, 32)
            }
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
            SearchHistoryCard(viewModel: SearchHistoryCardViewModel(SearchHistoryModel(persistence: SearchHistoryUserDefaults())))
            SearchHistoryCard(viewModel: SearchHistoryCardViewModel(SearchHistoryModel(persistence: SearchHistoryUserDefaults())))
                .preferredColorScheme(.dark)
            
        }.previewLayout(.fixed(width: 300, height: 220))
    }
}
