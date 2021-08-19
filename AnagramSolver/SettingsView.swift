//
//  SettingsView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 18/08/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel = SettingsViewModel()

    private var showKeyboardToggle : some View {
        Toggle(isOn: $viewModel.showKeyboard) {
            Text("Automatically show keyboard")
        }
    }

    private var longPressToggle : some View {
        Toggle(isOn: $viewModel.isLongPressEnabled) {
            Text("Allow long press on results")
        }
    }
    
    private var subAnagramsToggle : some View {
        Toggle(isOn: $viewModel.showSubAnagrams) {
            Text("Show sub-anagrams")
        }
    }

    private var tipsToggle : some View {
        Toggle(isOn: $viewModel.showCardTips) {
            if viewModel.showCardTips {
                Text("Show tips as cards")
            } else {
                Text("Show tips as a list")
            }
        }
    }

    private var monospacedToggle : some View {
        Toggle(isOn: $viewModel.useMonospacedFont) {
            Text("Use monospaced font")
        }
    }

    var body: some View {
        Form {
            Section(header: Text("SEARCH"),
                    footer: Text("There are 9 built-in word lists to choose from including Spanish, French and lists for Scrabble")){
                
                SettingsPicker(label: "Word list",
                               titles: Settings.wordListTitles,
                               values: Settings.wordListValues,
                               selection: $viewModel.wordList)
                
                SettingsPicker(label: "Dictionary definition",
                               titles: Settings.definitionTitles,
                               values: Settings.definitionValues,
                               selection: $viewModel.definition)
                
                SettingsPicker(label: "Results limit",
                               titles: Settings.resultsLimitTitles,
                               values: Settings.resultsLimitValues,
                               selection: $viewModel.resultsLimit)

                if #available(iOS 14.0, *) {
                    subAnagramsToggle
                        .toggleStyle(SwitchToggleStyle(tint: Color("materialButton")))
                } else {
                    subAnagramsToggle
                }
            }

            Section(header: Text("APPEARANCE"),
                    footer: Text("Use a monospaced font for the query field and results")){

                SettingsPicker(label: "Letter highlighting",
                               titles: Settings.highlightTitles,
                               values: Settings.highlightValues,
                               selection: $viewModel.highlight)

                if #available(iOS 14.0, *) {
                    tipsToggle
                        .toggleStyle(SwitchToggleStyle(tint: Color("materialButton")))
                } else {
                    tipsToggle
                }

                if #available(iOS 14.0, *) {
                    monospacedToggle
                        .toggleStyle(SwitchToggleStyle(tint: Color("materialButton")))
                } else {
                    monospacedToggle
                }
            }

            Section(header: Text("OTHER")){
                if #available(iOS 14.0, *) {
                    showKeyboardToggle
                        .toggleStyle(SwitchToggleStyle(tint: Color("materialButton")))
                } else {
                    showKeyboardToggle
                }

                if #available(iOS 14.0, *) {
                    longPressToggle
                        .toggleStyle(SwitchToggleStyle(tint: Color("materialButton")))
                } else {
                    longPressToggle
                }
            }
        }.navigationBarTitle(Text("Settings"), displayMode: .inline)
        .onDisappear(){
            Coordinator.sharedInstance.updateSettings()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
