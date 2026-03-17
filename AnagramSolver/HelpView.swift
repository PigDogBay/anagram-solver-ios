//
//  HelpView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 19/04/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    @Environment(AppViewModel.self) var appVM
    let tip : Tip

    var body: some View {
        Form {
            HelpTitleView(title: tip.title)

            Text(tip.description)
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
            VStack(alignment: .leading) {
                Text("Example")
                    .font(.headline)
                    .underline()
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                Text("Try ")+Text(tip.showMe).foregroundColor(Color("exampleQuery")) + Text(" to find:")
                Text(tip.example)
                    .foregroundColor(Color("exampleResult"))
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                HStack {
                    Spacer()
                    Button(action: {appVM.showMe(example: tip.showMe)}){
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

                Text(tip.advanced)
                    .lineLimit(nil)
                    .frame(maxHeight: .infinity)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarIconButton(placement: .topBarLeading, iconName: "chevron.left", action: appVM.goBack)
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(tip: tipsData[0])
    }
}
