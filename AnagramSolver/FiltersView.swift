//
//  FilterView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 24/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct FiltersView: View {
    @Environment(AppViewModel.self) var appVM
    @State var keyboard = Keyboard()
    @Bindable var filters : Filters

    private let numberFilters = ["No filter", "1 letter", "2 letters", "3 letters", "4 letters", "5 letters", "6 letters", "7 letters", "8 letters", "9 letters", "10 letters", "11 letters", "12 letters", "13 letters", "14 letters", "15 letters", "16 letters", "17 letters", "18 letters", "19 letters", "20 letters"]
    private let distinctFilters = ["No filter", "All letters are different", "Some letters are the same"]
    
    private var letterFilters : some View {
        Section(header: Text("FILTER BY LETTERS"), footer: Text("Letters can be in any order here")){
            TextFilterRow(label: "Contains", hint: "Enter letters", text: $filters.contains)
            TextFilterRow(label: "Excludes", hint: "Enter letters", text: $filters.excludes)
            FilterPicker(label: "Distinct", values: distinctFilters, selection: $filters.distinctSelection)
        }
    }
    
    private var wordFilters : some View {
        Section(header: Text("FILTER BY WORDS"), footer: Text("Find results that contain or exclude a word. Split multiple words with spaces, eg 'st ing'")){
            TextFilterRow(label: "Contains Word", hint: "Enter word", text: $filters.containsWord)
            TextFilterRow(label: "Excludes Word", hint: "Enter word", text: $filters.excludesWord)
        }
    }
    
    private var prefixSuffixFilters : some View {
        Section(header: Text("PREFIX / SUFFIX"), footer: Text("Find results starting or ending with your specified letters. Press the switches for NOT.")){
            Toggle(isOn: $filters.isStartingWithNotEnabled) {
                if filters.isStartingWithNotEnabled {
                    Text("Not Starting With")
                } else {
                    Text("Starting With")
                }
            }.modifier(ToggleMod())
            TextFilterRow(label: "Prefix", hint: "Enter prefix", text: $filters.prefix)

            Toggle(isOn: $filters.isEndingWithNotEnabled) {
                if filters.isEndingWithNotEnabled {
                    Text("Not Ending With")
                } else {
                    Text("Ending With")
                }
            }.modifier(ToggleMod())
            TextFilterRow(label: "Suffix", hint: "Enter suffix", text: $filters.suffix)
        }
    }
    
    private var sizeFilters : some View {
        Section(header: Text("FILTER BY WORD SIZE"), footer: Text("")){
            FilterPicker(label: "Equal To", values: numberFilters, selection: $filters.equalTo)
            FilterPicker(label: "More Than", values: numberFilters, selection: $filters.moreThan)
            FilterPicker(label: "Less Than", values: numberFilters, selection: $filters.lessThan)
        }
    }
    
    private var expertFilters : some View {
        return Section(header: Text("EXPERT FILTERS"), footer: Text("To create a pattern use ? to represent any letter and @ for 0 or more letters, eg s?r??b?e")){
            TextFilterRow(label: "Pattern", hint: "Enter pattern", text: $filters.pattern)
                .onChange(of: filters.pattern){ oldValue, newValue in
                    if (oldValue != newValue) {
                        self.filters.pattern = keyboard.crossword(typed: newValue)
                    }
                }
            TextFilterRow(label: "Reg Exp", hint: "Enter regex", text: $filters.regExp)
        }
    }

    var body: some View {
        Form {
            letterFilters
            wordFilters
            prefixSuffixFilters
            expertFilters
            sizeFilters
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle(filters.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarIconButton(placement: .topBarLeading, iconName: "chevron.left", action: appVM.goBack)
            ToolbarButton(placement: .topBarTrailing, label: "Apply"){appVM.apply(filters: filters)}
        }
        .navigationBarBackButtonHidden(true)
    }
}
