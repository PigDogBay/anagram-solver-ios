//
//  DefinitionHeaderRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 23/03/2023.
//  Copyright © 2023 Mark Bailey. All rights reserved.
//

import SwiftUI
import SwiftUtils
import AVFoundation

/*
 Make it global for now
 If created in the struct, will generate 50+ AXSpeech threads and run out of memory (app will lock up)
 Since the struct is created for every result and may be re-created every time there is a state change
 really bad to put object creation in SwiftUI View structs.
 */
let synthesizer = AVSpeechSynthesizer()

struct DefinitionHeaderRow: View {
    let title : String
    @State private var speakIconScale : CGFloat = 1
    @State private var searchIconScale : CGFloat = 1

    private func speak(){
        mpdbSpeak(synth: synthesizer, text: title)
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
        Coordinator.sharedInstance.webLookUp(word: title)
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
