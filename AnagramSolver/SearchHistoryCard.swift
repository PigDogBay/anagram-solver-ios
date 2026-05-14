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
    @Environment(AppViewModel.self) var appVM
    
    var viewModel : SearchHistoryModel {
        return appVM.model.searchHistoryModel
    }

    private var historyLinks : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            ForEach(viewModel.history, id: \.self) { historyItem in
                Text(LocalizedStringKey(historyItem))
                    .tint(Color("exampleQuery"))
            }
        }
    }
    private var noHistory : some View {
        Text("Lists your previous searches")
    }

    private var buttons : some View {
        HStack(){
            Button(action:{viewModel.clearSearchHistory()}){
                Text("CLEAR")
                    .modifier(ButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action: {appVM.goto(screen: .SearchHistory)}){
                Text("SHOW ALL")
                    .modifier(ButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
        }
    }

    var body: some View {
        //The history data is now observable, but I can track this variable to listen for history updates
        //let _ = viewModel.forceUIRefresh
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
        .onAppear{
            viewModel.onCardAppear()
        }
        .environment(\.openURL, OpenURLAction { url in
            if let query = url.absoluteString.removingPercentEncoding{
                appVM.showMe(example: query)
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
