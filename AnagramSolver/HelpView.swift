//
//  HelpView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 19/04/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    private let coordinator = Coordinator.sharedInstance
    @ObservedObject var viewModel : HelpViewModel

    var body: some View {
        Form {
            HStack {
                Spacer()
                Image(systemName: "lightbulb")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.yellow)
                    .padding(8)
                Text(viewModel.tip.title)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                Spacer()
            }
            Text(viewModel.tip.description)
                .padding(8)
            VStack(alignment: .leading) {
                Text("Example")
                    .font(.headline)
                    .underline()
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                Text("Try ")+Text(viewModel.tip.showMe).foregroundColor(Color("exampleQuery")) + Text(" to find:")
                Text(viewModel.tip.example)
                    .foregroundColor(Color("exampleResult"))
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                HStack {
                    Spacer()
                    Button(action: {self.viewModel.showMe(coordinator: self.coordinator)}){
                        Text("SHOW ME")
                            .modifier(TipButtonMod())
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
            .padding(8)
            
            VStack(alignment: .leading) {
                Text("More Info")
                    .font(.headline)
                    .underline()
                    .padding(.top, 8)
                    .padding(.bottom, 16)

                Text(viewModel.tip.advanced)
                    .lineLimit(nil)
                    .frame(maxHeight: .infinity)
                    .font(.body)
            }
            .padding()
        }
        .navigationBarTitle(Text("Help"), displayMode: .inline)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(viewModel: HelpViewModel(tip: tipsData[0]))
    }
}
