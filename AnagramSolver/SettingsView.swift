//
//  SettingsView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 18/08/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    //Env var used to dismiss this nav view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var viewModel = SettingsViewModel()
    @State private var showDefaultSettingsAlert = false

    ///Update settings when user presses the back button
    private func backPressed(){
        Coordinator.sharedInstance.updateSettings()
        self.mode.wrappedValue.dismiss()
    }

    private var showKeyboardToggle : some View {
        Toggle(isOn: $viewModel.showKeyboard) {
            Text("Automatically show keyboard")
        }.modifier(ToggleMod())
    }

    private var longPressToggle : some View {
        Toggle(isOn: $viewModel.isLongPressEnabled) {
            Text("Allow long press on results")
        }.modifier(ToggleMod())
    }
    
    private var subAnagramsToggle : some View {
        Toggle(isOn: $viewModel.showSubAnagrams) {
            Text("Show sub-anagrams")
        }.modifier(ToggleMod())
    }

    private var tipsToggle : some View {
        Toggle(isOn: $viewModel.showCardTips) {
            if viewModel.showCardTips {
                Text("Show tips as cards")
            } else {
                Text("Show tips as a list")
            }
        }.modifier(ToggleMod())
    }

    private var monospacedToggle : some View {
        Toggle(isOn: $viewModel.useMonospacedFont) {
            if viewModel.useMonospacedFont {
                Text("Use monospaced font")
                    .font(.system(.body,design: .monospaced))
            } else {
                Text("Use normal font")
            }
        }.modifier(ToggleMod())
    }

    private var useUpperCaseToggle : some View {
        Toggle(isOn: $viewModel.useUpperCase) {
            if viewModel.useUpperCase {
                Text("UPPERCASE LETTERS")
            } else {
                Text("Lowercase letters")
            }
        }.modifier(ToggleMod())
    }

    private var dictationToggle : some View {
        Toggle(isOn: $viewModel.allowDictation) {
            if viewModel.allowDictation {
                HStack {
                    Text("Allow dictation")
                    Image(systemName: "mic")
                }
            } else {
                HStack {
                    Text("No dictation")
                    Image(systemName: "mic.slash")
                }
            }
        }.modifier(ToggleMod())
    }
    
    private var largeFontToggle : some View {
        Toggle(isOn: $viewModel.useLargeResultsFont){
            if viewModel.useLargeResultsFont {
                Text("Large Results Font")
                    .font(.system(.title))
            } else {
                Text("Small Results Font")
            }
        }.modifier(ToggleMod())
    }
    
    private var searchHistoryToggle : some View {
        Toggle(isOn: $viewModel.isSearchHistoryEnabled) {
            if viewModel.isSearchHistoryEnabled {
                Text("Search history is on")
            } else {
                Text("Search history is off")
            }
        }.modifier(ToggleMod())
    }


    private var settingsForm : some View {
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

                subAnagramsToggle
            }

            Section(header: Text("APPEARANCE"),
                    footer: Text("The results font can be small or large")){

                SettingsPicker(label: "Letter highlighting",
                               titles: Settings.highlightTitles,
                               values: Settings.highlightValues,
                               selection: $viewModel.highlight)

                SettingsPicker(label: "Dark Mode",
                               titles: Settings.darkModeTitles,
                               values: Settings.darkModeValues,
                               selection: $viewModel.darkModeOverride)

                tipsToggle
                //Set identifier for UI testing
                useUpperCaseToggle.accessibilityIdentifier("caseToggle")
                largeFontToggle
            }

            Section(header: Text("KEYBOARD"),
                    footer: Text("Use a monospaced font for the query and filter input fields")){
                showKeyboardToggle
                dictationToggle

                Toggle(isOn: $viewModel.spaceToQuestionMark) {
                    Text("Convert space to ?")
                }.modifier(ToggleMod())
                .accessibilityIdentifier("convertSpaceToggle")

                Toggle(isOn: $viewModel.fullStopToQuestionMark) {
                    Text("Convert . to ?")
                }.modifier(ToggleMod())
                .accessibilityIdentifier("convertFullStopToggle")
                monospacedToggle
            }

            Section(header: Text("OTHER")){
                searchHistoryToggle
                longPressToggle
            }
        }
        .navigationBarTitle(Text("Settings"), displayMode: .inline)
    }

    var body: some View {
        settingsForm
            .navigationBarItems(trailing: Button("Reset"){
                    showDefaultSettingsAlert = true
                }.tint(Color.white))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: backPressed){
                HStack {
                    Image(systemName: "chevron.left")}
                        .padding(.trailing, -4)
                    Text("Back")
                }.tint(Color.white)
            )
            .alert("Use Default Settings", isPresented: $showDefaultSettingsAlert){
                Button("Default settings", role: .destructive){viewModel.resetToDefaultSettings()}
                    .accessibilityIdentifier("dialogResetSettings")
                Button("Cancel", role: .cancel){}
            }
    }
}

struct ToggleMod : ViewModifier {
    func body(content: Content) -> some View {
        content
            .toggleStyle(SwitchToggleStyle(tint: Color("toggle")))
    }
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
