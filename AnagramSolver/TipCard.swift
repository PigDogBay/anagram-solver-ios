//
//  TipCard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 16/07/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

let TIP_TEXT_SPACING = CGFloat(10.0)

struct TipCard: View {
    let tip : Tip
    @ObservedObject var coordinator : Coordinator
    @State var selection : Int? = nil
    
    private var description : some View {
        VStack(alignment: .leading, spacing: TIP_TEXT_SPACING){
            Text(tip.subtitle)
            showMeExample
            Text(tip.example)
                .foregroundColor(Color("exampleResult"))
        }
    }
    private var showMeExample : some View {
        HStack(spacing: 0) {
            Text("Try ")
            Text(tip.showMe)
                .foregroundColor(Color("exampleQuery"))
            Text(" to find:")
        }
    }
    
    private var buttons : some View {
        HStack(){
            Button(action:{self.selection = 1}){
                Text("MORE INFO")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action: {coordinator.showHelpExample(example: tip.showMe)}){
                Text("SHOW ME")
                    .modifier(TipButtonMod())
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            CardTitle(title: tip.title, icon: "lightbulb_on")
                .padding(.top,16)
            description
                .padding(.top,2)
            buttons
                .padding(16)
            NavigationLink(destination: HelpView(coordinator: coordinator, viewModel: HelpViewModel(tip: tip)), tag: 1, selection: $selection){
                EmptyView()
            }
        }
    }
}


struct CardTitle : View {
    let title : String
    let icon : String

    var body: some View {
        HStack {
            Image(icon)
                .scaleEffect(CGSize(width: 1.25,height: 1.25))
                .padding(16)
            Spacer()
            if #available(iOS 14.0, *) {
                Text(title).font(.title2.bold())
            } else {
                Text(title).font(.title)
            }
            Spacer()
            Spacer()
        }
    }
}

struct TipButtonMod : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote.bold())
            .foregroundColor(Color("materialButton"))
    }
}

struct TipCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TipCard(tip: tipsData[0],coordinator: Coordinator())
                .preferredColorScheme(.dark)
            TipCard(tip: tipsData[1],coordinator: Coordinator())
            TipCard(tip: tipsData[2],coordinator: Coordinator())
        }
        .previewLayout(.fixed(width: 300, height: 210))
    }
}
