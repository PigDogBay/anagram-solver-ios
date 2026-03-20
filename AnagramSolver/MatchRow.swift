//
//  MatchRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 05/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI
import SwiftUtils

struct MatchRow: View {
    @Environment(SpeechManager.self) var speech
    @State private var speakIconScale : CGFloat = 1
    @State private var copyIconScale : CGFloat = 1
    @State private var isCopiedVisible = false
    let match : String
    let formatter : IWordFormatter
    let largeFont : Bool

    private var textStyle : Font {
        return largeFont ? Font.title : Font.body
    }
    
    private func speak(){
        speech.speak(match)
        withAnimation(Animation.easeOut(duration: 0.5)){
            speakIconScale = 2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.easeOut(duration: 0.5)){
                speakIconScale = 1
            }
        }
    }
    
    private func copy(){
        UIPasteboard.general.string = match
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        //Animate the fade in of the Copied text
        //(Note opacity is the default transition)
        withAnimation{
            isCopiedVisible = true
        }
        withAnimation(Animation.easeOut(duration: 0.2)){
            copyIconScale = 2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(Animation.easeOut(duration: 0.1)){
                self.copyIconScale = 1
            }
        }
        //Animate the fade out of the Copied text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation{
                isCopiedVisible = false
            }
        }
    }
    
    var body: some View {
        ZStack {
            HStack {
                Text(AttributedString(formatter.formatAttributed(match)))
                    .font(textStyle)
                Spacer()
                Image(systemName: "speaker.3")
                    .foregroundColor(Color("accentColor"))
                    .padding(.trailing,8)
                    .onTapGesture(perform: speak)
                    .scaleEffect(speakIconScale)
                Image(systemName: "doc.on.doc")
                    .foregroundColor(Color("accentColor"))
                    .padding(.trailing,8)
                    .onTapGesture(perform: copy)
                    .scaleEffect(copyIconScale)
            }.padding(8)
            if isCopiedVisible {
                Text("Copied")
                    .foregroundColor(Color.white)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                    .padding(.top,6)
                    .padding(.bottom,6)
                    .background(Capsule().fill(Color.blue))
            }
        }
    }
}

struct MatchRow_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MatchRow(match: "astronomer", formatter: WordFormatter(), largeFont: false)
        }.previewLayout(.fixed(width: 300, height: 70))
    }
}
