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
    
    @ObservedObject var viewModel = SearchHistoryViewVM(Model.sharedInstance.searchHistoryModel)
    
    private let coordinator = Coordinator.sharedInstance

    var body: some View {
        List {
            ForEach(viewModel.history, id: \.self) { historyItem in
                HistoryItem(query: historyItem)
                    .onTapGesture {
                        self.coordinator.showHelpExample(example: historyItem)
                        viewModel.refreshRequired = true
                    }
            }
        }
        .listStyle(.plain)
        .navigationBarTitle(Text("History"), displayMode: .inline)
        .navigationBarItems(trailing: Button("Clear"){
            viewModel.clearHistory()
            }.tint(Color.white))
        .onAppear {
            viewModel.onAppear()
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
