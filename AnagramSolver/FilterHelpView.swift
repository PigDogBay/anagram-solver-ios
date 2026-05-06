//
//  FilterHelpView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 29/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct FilterSectionView: View {
    let title : String
    let description : String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.top, 8)
                .padding(.bottom, 8)

            Text(description)
                .lineLimit(nil)
                .frame(maxHeight: .infinity)
                .font(.body)
        }
        .padding(8)
    }
}

struct FilterHelpView: View {
    @Environment(AppViewModel.self) var appVM

    var body: some View {
        Form {
            Section{
                HelpTitleView(title: "Filters", icon: "funnel")
                    .listRowSeparator(.hidden)
                Text("To reduce the number of matches you can add extra search criteria. First enter your query and perform a search, next press the Filter button, you will be taken to the filters screen.\n\nSet up your filters and press the Search button, the app will go back to the results screen and perform the search again and apply any filters you have set.\n\nTip! Going back to the main screen will disable the filters. You can edit the main query from the filters screen to save time.")
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
            }
            Section(header: Text("FILTER BY LETTERS"), footer: Text("Contains and Excludes filters are great for Wordle")){
                FilterSectionView(title: "CONTAINS", description: "The order of the letters does not matter and you can specify a letter more than once. So 'Contains aabc' will only allow matches that contain at least 2 a's, 1 b and 1 c.")
                FilterSectionView(title: "EXCLUDES", description: "Removes any matches that contain any of the letters that you specify.")
                FilterSectionView(title: "DISTINCT", description: "This has two modes, allow words where all the letters are different or only allow words where some letters are the same. \n\nTip! Use the Distinct and Exclude filters for Codeword puzzles.")
            }
            Section(header: Text("FILTER BY WORDS")){
                FilterSectionView(title: "CONTAINS WORD", description: "Only allows matches that contain the specified word(s). Separate multiple words with spaces, all specified words must be in the result.")
                FilterSectionView(title: "EXCLUDES WORD", description: "Only allows matches that do NOT contain the specified word(s). Separate multiple words with spaces, a result will be excluded if it contains any of the specified words.")
            }
            Section(header: Text("PREFIX / SUFFIX")){
                FilterSectionView(title: "PREFIX", description: "Only allow matches that start with the specified words.\n\nTip! For Scrabble, enter your rack letters and letters of the word on the board in the main search query.")
                FilterSectionView(title: "SUFFIX", description: "Only allow matches end with the specified words.")
            }
            Section(header: Text("WORD SIZE")){
                FilterSectionView(title: "EQUAL, MORE AND LESS THAN", description: "Only allow words that are equal to, smaller than or greater than the specified size.\n\nThese filters are useful for anagram searches when you need to find words of a certain length, for example in WordScapes where you need to find those last few pesky 3 letter words.")
            }
           Section(header: Text("EXPERT FILTERS"), footer: Text("Use * for the main search query to filter against the entire word list.")){
               FilterSectionView(title: "PATTERN FILTER", description: "Similar to a Crossword search, use . for an unknown letter.  So .tr... will look for 6 letter words where the second letter is a t and the third an r. This is useful for Scrabble games where you specify the letters on the board you want to use. You also can use @ to mean 0 or more letters.")
               FilterSectionView(title: "REG EXP", description: "Create powerful search patterns using Regular Expression.\n\nExamples\n [aeiou] letter must be a vowel.\n [a-z]+ any letter one or more times.\n [aeiou][a-z]+[aeiou] Matches words that start and end with a vowel.")
            }
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarIconButton(placement: .topBarLeading, iconName: "chevron.left", action: appVM.goBack)
        }
    }}

struct FilterHelpView_Previews: PreviewProvider {
    static var previews: some View {
        FilterHelpView()
    }
}
