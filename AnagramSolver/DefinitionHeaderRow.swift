//
//  DefinitionHeaderRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 23/03/2023.
//  Copyright © 2023 Mark Bailey. All rights reserved.
//

import SwiftUI
import SwiftUtils

struct DefinitionHeaderRow: View {
    @Environment(AppViewModel.self) var appVM
    @Environment(SpeechManager.self) var speech
    
    let title : String
    @State private var speakCount = 0
    @State private var searchCount = 0

    private func speak(){
        speakCount+=1
        // Add a light haptic "click"
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        speech.speak(title)
    }
    
    private func webLookUp(){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        searchCount+=1
        appVM.webLookUp(word: title)
    }
    
    var body: some View {
        HStack {
            Image(systemName: "speaker.wave.3.fill")
                .foregroundColor(Color("accentColor"))
                .padding([.leading,.trailing],4)
                .symbolEffect(.bounce, value: speakCount)
                .onTapGesture(perform: speak)
            Text(title)
                .font(.headline)
                .textCase(.uppercase)
                .listRowSeparator(.hidden)
            Spacer()
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("accentColor"))
                .padding(.trailing,16)
                .symbolEffect(.bounce, value: searchCount)
                .onTapGesture(perform: webLookUp)
        }
    }
}

struct DefinitionHeaderRow_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionHeaderRow(title: "magic")
    }
}
