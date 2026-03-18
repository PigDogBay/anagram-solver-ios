//
//  HelpOutCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 23/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct HelpOutCard: View {
    @State var aboutVM = AboutViewModel()
    @State private var isPresented: Bool = false
    
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
            Button(action:{isPresented = true}){
                Text("TELL")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action:AboutViewModel.rate){
                Text("RATE")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action:aboutVM.feedback){
                Text("FEEDBACK")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
        }
        .sheet(isPresented: $isPresented){
            ActivityViewController(activityItems: [Strings.tellFriends])
        }
        .sheet(isPresented: $aboutVM.isMailVCPresented, content: {MailView(recipient: Strings.emailAddress, subject: Strings.feedbackSubject, result: self.$aboutVM.result)})
        .alert(isPresented: $aboutVM.showNoEmailAlert){
            Alert(title: Text("Email Not Supported"), message: Text("Please email me at: \(Strings.emailAddress)"), dismissButton: .default(Text("OK")))
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
