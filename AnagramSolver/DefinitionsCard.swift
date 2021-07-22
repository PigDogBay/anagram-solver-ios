//
//  DefinitionsCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 22/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct DefinitionsCard: View {
    @State var selection : Int? = nil

    private var description : some View {
        VStack(alignment: .leading, spacing: 5){
            Text("Tap on a result's info icon")
            Text("to look up the word on the web.")
            Text("Touch and hold a result to")
            Text("to bring up a menu of options.")
        }
    }

    private var buttons : some View {
        HStack(){
            Button(action:{self.selection = 1}){
                Text("MORE INFO")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            CardTitle(title: "Definitions", icon: "definition")
                .padding(.top,16)
            description
                .padding(.top,2)
            buttons
                .padding(16)
            NavigationLink(destination: DefinitionHelpView(), tag: 1, selection: $selection){
                    EmptyView()
            }
            
        }
    }
}

struct DefinitionsCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DefinitionsCard()
            DefinitionsCard()
                .preferredColorScheme(.dark)
            
        }.previewLayout(.fixed(width: 300, height: 240))
    }
}
