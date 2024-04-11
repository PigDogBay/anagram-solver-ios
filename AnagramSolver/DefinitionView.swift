//
//  DefinitionView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 22/03/2023.
//  Copyright © 2023 Mark Bailey. All rights reserved.
//

import SwiftUI
import SwiftUtils

struct DefinitionView: View {
    @ObservedObject var viewModel : DefinitionViewModel
    
    init(_ dictionary : WordDictionary){
        viewModel = DefinitionViewModel(dictionary)
    }
    
    var body: some View {

        List {
            ForEach(viewModel.definitionItems){item in
                switch item.type {
                case .word:
                    DefinitionHeaderRow(title: item.text)
                        .listRowSeparator(.hidden)
                        .padding(.top, 16)
                case .synonyms:
                    DefinitionSynonymsRow(partOfSpeech: viewModel.createPartOfSpeech(synonymsText: item.text),
                                          synonyms: LocalizedStringKey(viewModel.createMarkdown(synonymsText: item.text)))
                        .listRowSeparator(.hidden)
                        .padding([.leading,.trailing],4)
                        .padding(.top, 18)
                        .padding(.bottom, 4)
                        .environment(\.openURL, OpenURLAction { url in
                            viewModel.synonymTapped(url)
                            return .discarded
                        })
                case .definition:
                    Text(item.text)
                        .listRowSeparator(.hidden)
                        .padding([.leading,.trailing],4)
                        .padding([.top, .bottom], 0)
                case .example:
                    Text(item.text)
                        .italic()
                        .listRowSeparator(.hidden)
                        .padding([.leading,.trailing],4)
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                }
            }
        }.listStyle(.plain)
        .navigationBarTitle(Text("Dictionary"), displayMode: .inline)
    }
}

struct DefinitionView_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionView(MagicWordDictionary())
    }
}
