//
//  FilterCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 22/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct FilterCard: View {
    @State var selection : Int? = nil

    private var description : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            Text("Too many matches?")
            Text("Refine your search, filter by")
            Text("* Word size")
            Text("* Letters in the word")
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
            CardTitle(title: "Filter Results", icon: "funnel")
                .padding(.top,16)
            description
                .padding(.top,2)
            buttons
                .padding(16)
            NavigationLink(destination: FilterHelpView(), tag: 1, selection: $selection){
                    EmptyView()
            }
            
        }
    }
}

struct FilterCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FilterCard()
            FilterCard()
                .preferredColorScheme(.dark)
            
        }.previewLayout(.fixed(width: 300, height: 240))
    }
}
