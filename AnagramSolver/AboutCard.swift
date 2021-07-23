//
//  AboutCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 23/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct AboutCard: View {
    @ObservedObject var coordinator : Coordinator
    @State var selection : Int? = nil

    private var description : some View {
        VStack(alignment: .leading, spacing: 5){
            Text("* Information about the app")
            Text("* Set your Ad preferences")
            Text("* View the privacy policy")
        }
    }

    private var buttons : some View {
        HStack(){
            Spacer()
            Button(action:{self.selection = 1}){
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
            NavigationLink(destination: AboutView(coordinator: coordinator), tag: 1, selection: $selection){
                    EmptyView()
            }
            
        }
    }
}

struct AboutCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AboutCard(coordinator: Coordinator())
            AboutCard(coordinator: Coordinator())
                .preferredColorScheme(.dark)
            
        }.previewLayout(.fixed(width: 300, height: 240))
    }
}
