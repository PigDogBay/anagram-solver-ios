//
//  SettingsCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 22/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI
import SwiftUtils

struct SettingsCard: View {
    @State var selection : Int? = nil

    private var description : some View {
        VStack(alignment: .leading, spacing: 5){
            Text("Select the word list")
            Text("Choose dictionary definition")
            Text("Change the appearance")
        }
    }

    private var buttons : some View {
        HStack(){
            Button(action:{self.selection = 1}){
                Text("MORE INFO")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action: mpdbShowSettings){
                Text("SHOW SETTINGS")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            CardTitle(title: "Settings", icon: "gear")
                .padding(.top,16)
            description
                .padding(.top,2)
            buttons
                .padding(16)
            NavigationLink(destination: SettingsHelpView(), tag: 1, selection: $selection){
                    EmptyView()
            }
            
        }
    }
}

struct SettingsCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsCard()
            SettingsCard()
                .preferredColorScheme(.dark)
            
        }.previewLayout(.fixed(width: 300, height: 220))
    }
}
