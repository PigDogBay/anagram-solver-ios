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
                .font(.body)
        }
        .padding(8)
    }
}

struct DefinitionHelpView: View {
    var body: some View {
        Form {
            HStack {
                Spacer()
                Image(systemName: "info.circle")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.green)
                    .padding()
                Text("Definitions")
                    .font(.largeTitle)
                Spacer()
            }
            HelpSectionView(title: "Look up", icon: "book", description: "To look up a word\'s meaning, tap on the information icon on the right hand side of the word. The app will open a web browser to look up the word on the web.\n\nYou can change which website to use in the Dictionary definition setting in the app's settings.")
            HelpSectionView(title: "Long Press", icon: "hand.point.right", description: "Touch and hold a word to bring up a menu to choose which website to look up the word.\n\nIf you are stuck on a crossword, enter the clue and look it up on the M-W Thesaurus for suggestions.\n\nFor Scrabble players, select the Word Game Dictionary to check if the word is allowed.")
            HelpSectionView(title: "Speak", icon: "speaker.3", description: "From the long press menu select Speak for the app to say the word.")
            HelpSectionView(title: "Copy", icon: "doc.on.doc", description: "From the long press menu select Copy to copy the word onto the clipboard. You can then paste the word into other apps.")
            HelpSectionView(title: "Settings", icon: "gear", description: "Change the default look up website in the Dictionary definition setting in the app's settings.")
        }
        .navigationBarTitle(Text("Help"), displayMode: .inline)
    }
    
}

struct DefintionHelpView_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionHelpView()
    }
}
