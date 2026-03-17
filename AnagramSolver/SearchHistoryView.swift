//
//  SearchHistoryView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 06/02/2025.
//  Copyright © 2025 MPD Bailey Technology. All rights reserved.
//

import SwiftUI


class SearchHistoryViewVM : ObservableObject {
    @Published var refreshRequired = false
    
    let historyModel : SearchHistoryModel

    init(_ historyModel : SearchHistoryModel){
        self.historyModel = historyModel
    }

    var history : [String] { return
            historyModel
            .searchHistory
            .getHistory()
    }

    func clearHistory(){
        historyModel.clearSearchHistory()
        objectWillChange.send()
    }
    func onAppear(){
        if refreshRequired {
            refreshRequired = false
        }
    }
}

struct HistoryItem : View {
    let query : String
    var body: some View {
        HStack {
            Image(systemName: "fossil.shell")
                .foregroundColor(Color("accentColor"))
                .padding(8)
            Text(query)
            Spacer()
        }
    }
}

struct SearchHistoryView: View {
    
    @Environment(AppViewModel.self) var appVM
    @State var viewModel : SearchHistoryViewVM

    var body: some View {
        List {
            ForEach(viewModel.history, id: \.self) { historyItem in
                HistoryItem(query: historyItem)
                    .contentShape(Rectangle()) //Ensure row white space is tappable
                    .onTapGesture {
                        appVM.showMe(example: historyItem)
                        viewModel.refreshRequired = true
                    }
            }
        }
        .listStyle(.plain)
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarIconButton(placement: .topBarLeading, iconName: "chevron.left", action: appVM.goBack)
            ToolbarButton(placement: .topBarTrailing, label: "Clear", action: viewModel.clearHistory)
        }
    }
}

struct HistoryItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            HistoryItem(query: "m.g..")
            HistoryItem(query: "m.g..")
            HistoryItem(query: "m.g..")
        }.listStyle(.plain)
    }
}
