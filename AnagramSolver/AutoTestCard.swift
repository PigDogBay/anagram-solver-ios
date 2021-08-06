//
//  AutoTestCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 23/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct AutoTestCard: View {
    @ObservedObject var coordinator : Coordinator

    private var description : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            Text("Generates random queries")
        }
    }

    private var buttons : some View {
        HStack(){
            Spacer()
            Button(action:coordinator.autoTest){
                Text("START")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            CardTitle(title: "Automated Testing", icon: "gear")
                .padding(.top,16)
            description
                .padding(.top,2)
            buttons
                .padding(16)
        }
    }
}

struct AutoTestCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AutoTestCard(coordinator: Coordinator())
            AutoTestCard(coordinator: Coordinator())
                .preferredColorScheme(.dark)
            
        }.previewLayout(.fixed(width: 300, height: 240))
    }
}
