//
//  UserGuideCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 23/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct UserGuideCard: View {

    private var description : some View {
        VStack(alignment: .leading, spacing: 5){
            Text("Online User Guide")
            Text("* In-depth help")
            Text("* Crack word games")
            Text("* Best ways to use filters")
        }
    }

    private var buttons : some View {
        HStack(){
            Spacer()
            Button(action:{UIApplication.shared.open(URL(string: Strings.userGuideURL)!, options: [:])}){
                Text("VIEW GUIDE")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            CardTitle(title: "User Guide", icon: "help")
                .padding(.top,16)
            description
                .padding(.top,2)
            buttons
                .padding(16)
        }
    }
}

struct UserGuideCard_Previews: PreviewProvider {
    static var previews: some View {
        UserGuideCard()
    }
}
