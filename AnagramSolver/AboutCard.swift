//
//  AboutCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 23/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct AboutCard: View {
    private let coordinator = Coordinator.sharedInstance

    private var description : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            Text("* Information about the app")
            Text("* Set your Ad preferences")
            Text("* View the privacy policy")
        }
    }

    private var buttons : some View {
        HStack(){
            Spacer()
            Button(action:{coordinator.show(coordinator.SHOW_ABOUT)}){
                Text("SHOW ABOUT")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            CardTitle(title: "About & Privacy", icon: "shield")
                .padding(.top,16)
            description
                .padding(.top,2)
            buttons
                .padding(16)
        }
    }
}

struct AboutCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AboutCard()
            AboutCard()
                .preferredColorScheme(.dark)
            
        }.previewLayout(.fixed(width: 300, height: 240))
    }
}
