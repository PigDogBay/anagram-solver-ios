//
//  SettingsHelpView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 22/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct SettingsHelpView: View {
    var body: some View {
        Form {
            HelpTitleView(title: "Settings")
            Text("The settings can be accessed by pressing the gear icon on the top left of the home screen.")
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
            FilterSectionView(title: "SEARCH", description: "Word List: The default word list is huge, over 310,000 words, containing many proper nouns and rare words not allowed in games. For word games choose the US or World Scrabble word lists so that the app only returns valid words. The Essential word list, 90,000 words, is ideal for many crosswords and puzzles where you only require common words.\n\nGerman, Spanish, Portuguese, Italian and French word lists are also available.\n\nDictionary Definition: Allows you to choose which website to use when looking up a word\'s meaning by pressing info icon.\n\nShow sub-anagrams: You can disable sub-anagrams so that the app will only return words that use all the letters in your query.")
            FilterSectionView(title: "APPEARANCE", description: "Letter highlighting: Controls the colour of blank letters in anagram searches.\n\nDark Mode allows you to chose a dark or light theme, by default the app will use the system dark mode setting.\n\nShow tips as cards: You can show the tips on the home screen as cards or as a compact list of items.\n\nChoose uppercase or lowercase for the query field and results\n\nThe results font size can be either small or large.")
            FilterSectionView(title: "KEYBOARD", description: "Automatically show keyboard: Pops up the keyboard when you return to the home screen.\n\nAllow dictation will change the keyboard layout to include a microphone button to allow speech to text entry.\n\nConvert Space to ? will emit a ? instead of a space character, ? represents an unknown letter in crossword queries.\n\nConvert . to ? will enter a ? character when you press . on the keyboard. Both . and ? represent an unknown letter.\n\nUse monospaced font: Display the query input text with a monospaced font. A monospaced font is useful for crossword searches as the unknowns(.) and letters are spaced equally.")
            FilterSectionView(title: "OTHER", description: "Search history: When off, your search history will not be saved and the History card will not be displayed. When on, search history will be stored on your device and displayed in the card.\n\nAllow long press on results: You can touch and hold a result to bring up a context menu of options, use this setting to enable or disable this feature.")
        }
        .navigationBarTitle(Text("Help"), displayMode: .inline)
    }
}

struct SettingsHelpView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHelpView()
    }
}
