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
            HStack {
                Spacer()
                Image(systemName: "gear")
                    .font(Font.system(.title))
                    .foregroundColor(Color.blue)
                Text("Settings")
                    .font(.title)
                Spacer()
            }.padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
            Text("The settings can be accessed by pressing the gear icon on the top left of the home screen.")
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
            FilterSectionView(title: "SEARCH SETTINGS", description: "Word List: The default word list is huge, over 310,000 words, containing many proper nouns and rare words not allowed in games. For word games choose the US or World Scrabble word lists so that the app only returns valid words. The Essential word list, 90,000 words, is ideal for many crosswords and puzzles where you only require common words.\n\nGerman, Spanish, Portuguese, Italian and French word lists are also available.\n\nDictionary Definition: Allows you to choose which website to use when looking up a word\'s meaning by pressing info icon.\n\nShow sub-anagrams: You can disable sub-anagrams so that the app will only return words that use all the letters in your query.")
            FilterSectionView(title: "APPEARANCE", description: "Letter highlighting: Controls the colour of blank letters in anagram searches.\n\nShow tips as cards: You can show the tips on the home screen as cards or as a compact list of items.\n\nUse monospaced font: Display the query and results text with a monospaced font. A monospaced font is useful for crossword searches as the unknowns(.) and letters are spaced equally.")
            FilterSectionView(title: "OTHER", description: "Automatically show keyboard: Pops up the keyboard when you return to the home screen.\n\nAllow long press on results: You can touch and hold a result to bring up a context menu of options, use this setting to enable or disable this feature.")
        }
        .navigationBarTitle(Text("Help"), displayMode: .inline)
    }
}

struct SettingsHelpView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHelpView()
    }
}
