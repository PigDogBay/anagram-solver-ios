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
    @ObservedObject var coordinator : Coordinator

    private var description : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            Text("* Select the word list")
            Text("* Choose dictionary definition")
            Text("* Change the appearance")
        }
    }

    private var buttons : some View {
        HStack(){
            Button(action:{coordinator.show(coordinator.SHOW_SETTINGS_HELP)}){
                Text("MORE INFO")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action: {coordinator.show(coordinator.SHOW_SETTINGS)}){
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
        }
    }
}

struct SettingsCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsCard(coordinator: Coordinator())
            SettingsCard(coordinator: Coordinator())
                .preferredColorScheme(.dark)
            
        }.previewLayout(.fixed(width: 300, height: 220))
    }
}
