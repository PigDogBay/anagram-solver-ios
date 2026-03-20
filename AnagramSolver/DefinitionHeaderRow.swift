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
    @State private var speakIconScale : CGFloat = 1
    @State private var searchIconScale : CGFloat = 1

    private func speak(){
        speech.speak(title)
        withAnimation(Animation.easeOut(duration: 0.5)){
            speakIconScale = 2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.easeOut(duration: 0.5)){
                speakIconScale = 1
            }
        }
    }
    
    private func webLookUp(){
        withAnimation(Animation.easeOut(duration: 0.25)){
            searchIconScale = 2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(Animation.easeOut(duration: 0.25)){
                searchIconScale = 1
            }
        }
        appVM.webLookUp(word: title)
    }
    
    var body: some View {
        HStack {
            Image(systemName: "speaker.wave.3.fill")
                .foregroundColor(Color("accentColor"))
                .padding([.leading,.trailing],4)
                .onTapGesture(perform: speak)
                .scaleEffect(speakIconScale)
            Text(title)
                .font(.headline)
                .textCase(.uppercase)
                .listRowSeparator(.hidden)
            Spacer()
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("accentColor"))
                .padding(.trailing,16)
                .onTapGesture(perform: webLookUp)
                .scaleEffect(searchIconScale)
        }
    }
}

struct DefinitionHeaderRow_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionHeaderRow(title: "magic")
    }
}
