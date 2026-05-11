//
//  DefintionHelpView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 05/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct HelpSectionView: View {
    let title : String
    let icon : String
    let description : String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.blue)
                    .padding(.trailing,8)
                Text(title)
                    .font(.headline)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
            }

            Text(description)
                .lineLimit(nil)
                .frame(maxHeight: .infinity)
                .font(.body)
        }
        .padding(8)
    }
}

struct DefinitionHelpView: View {
    @Environment(AppViewModel.self) var appVM
    var body: some View {
        Form {
            HelpTitleView(title: "Definitions", icon: "definition")
                .listRowSeparator(.hidden)
            HelpSectionView(title: "LOOK UP", icon: "book", description: "Tap on a result to look up a word\'s meaning. The app will search its built-in dictionary for the definition, if no definitions are found the app will open a web browser to look up the word on the web.\n\nYou can change which website to use in the Dictionary definition setting in the app's settings.")
            HelpSectionView(title: "LONG PRESS", icon: "hand.point.right", description: "Touch and hold a word to bring up a menu to choose which website to look up the word.\n\nIf you are stuck on a crossword, enter the clue and look it up on the M-W Thesaurus for suggestions.\n\nFor Scrabble players, select the Word Game Dictionary to check if the word is allowed.")
            HelpSectionView(title: "SPEAK", icon: "speaker.3", description: "Tap on a result's speaker icon for the app to say the word.")
            HelpSectionView(title: "COPY", icon: "doc.on.doc", description: "Tap on a result's copy icon to copy the result onto the clipboard. You can then paste the result into other apps.")
            HelpSectionView(title: "SETTINGS", icon: "gear", description: "Change the default look up website in the Dictionary definition setting in the app's settings.")
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarIconButton(placement: .topBarLeading, iconName: "chevron.left", action: appVM.goBack)
        }
    }
    
}

struct DefintionHelpView_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionHelpView()
    }
}
