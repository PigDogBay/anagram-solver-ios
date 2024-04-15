//
//  HelpOutCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 23/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct HelpOutCard: View {
    @ObservedObject var coordinator = Coordinator.sharedInstance

    private var description : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            Text("Keep updates coming")
            Text("* Rate the app")
            Text("* Send any suggestions")
            Text("* Tell your friends")
        }
    }

    private var buttons : some View {
        HStack(){
            //Using a @state variable to toggle the tell sheet does not work
            Button(action:{coordinator.showTell=true}){
                Text("TELL")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action:AboutViewModel.rate){
                Text("RATE")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action:coordinator.sendFeedback){
                Text("FEEDBACK")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
        }
        .sheet(isPresented: $coordinator.showTell){
            ActivityViewController(activityItems: [Strings.tellFriends])
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            CardTitle(title: "Help Out", icon: "heart")
                .padding(.top,16)
            description
                .padding(.top,2)
            buttons
                .padding(16)
        }
    }
}

struct HelpOutCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HelpOutCard()
            HelpOutCard()
                .preferredColorScheme(.dark)
            
        }.previewLayout(.fixed(width: 300, height: 240))
    }
}
