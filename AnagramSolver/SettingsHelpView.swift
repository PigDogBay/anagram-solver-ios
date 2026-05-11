//
//  SettingsHelpView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 22/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct SettingsHelpView: View {
    @Environment(AppViewModel.self) var appVM

    var body: some View {
        Form {
            Section {
                HelpTitleView(title: "Settings", icon: "gear")
                    .listRowSeparator(.hidden)
                Text("The settings can be accessed by pressing the gear icon on the top left of the home screen.")
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
            }
            Section(header: Text("SEARCH")){
                FilterSectionView(title: "WORD LIST", description: "The default word list is huge, over 310,000 words, containing many proper nouns and rare words not allowed in games. For word games choose the US or World Scrabble word lists so that the app only returns valid words. The Essential word list (90K words) is ideal for many crosswords and puzzles where you only require common words.\n\nGerman, Spanish, Portuguese, Italian and French word lists are also available.")
                FilterSectionView(title: "DICTIONARY DEFINITION", description: "Allows you to choose which website to use when the app uses a web-lookup for a word\'s meaning.")
                FilterSectionView(title: "SHOW SUB-ANAGRAMS", description: "You can disable sub-anagrams so that the app will only return words that use all the letters in your query.")
            }
            Section(header: Text("APPEARANCE")){
                FilterSectionView(title: "LETTER HIGHLIGHTING", description: "Controls the colour of blank letters in anagram searches.")
                FilterSectionView(title: "DARK MODE", description: "Allows you to chose a dark or light theme, by default the app will use the system dark mode setting.")
                FilterSectionView(title: "SHOW TIPS AS CARDS", description: "You can show the tips on the home screen as cards or as a compact list of items.")
                FilterSectionView(title: "CHOOSE UPPERCASE OR LOWERCASE", description: "Choose uppercase or lowercase for the query field and results.")
                FilterSectionView(title: "RESULTS SIZE", description: "The results font size can be either small or large.")
            }
            Section(header: Text("KEYBOARD")){
                FilterSectionView(title: "AUTOMATICALLY SHOW KEYBOARD", description: "Pops up the keyboard when you return to the home screen.")
                FilterSectionView(title: "SHOW THE SYMBOL BAR", description: "Enable to show a handy toolbar shortcut for the symbols ? + * $ @")
                FilterSectionView(title: "ALLOW DICTATION", description: "Changes the keyboard layout to include a microphone button to allow speech to text entry.")
                FilterSectionView(title: "CONVERT SPACE TO ?", description: "Pressing space emits a ? instead of a space character, ? represents an unknown letter in crossword queries.")
                FilterSectionView(title: "CONVERT . TO ?", description: "Pressing . emits a ? character instead of a full-stop/period. Both . and ? represent an unknown letter.")
                FilterSectionView(title: "USE MONOSPACED FONT", description: "Display the query input text with a monospaced font. A monospaced font is useful for crossword searches as the unknowns(.) and letters are spaced equally.")
            }
            Section(header: Text("OTHER")){
                FilterSectionView(title: "SEARCH HISTORY", description: "When off, your search history will not be saved and the History card will not be displayed. When on, search history will be stored on your device and displayed in the card.")
            }
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarIconButton(placement: .topBarLeading, iconName: "chevron.left", action: appVM.goBack)
        }
    }
}

struct SettingsHelpView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHelpView()
    }
}
