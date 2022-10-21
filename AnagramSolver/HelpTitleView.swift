//
//  HelpTitleView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 19/05/2022.
//  Copyright © 2022 Mark Bailey. All rights reserved.
//

import SwiftUI

struct HelpTitleView: View {
    let title : String
    var body: some View {
        HStack{
            Spacer()
            Image(systemName: "info.circle")
                .font(Font.system(.title))
                .foregroundColor(Color("iconYellow"))
            Text(title)
                .multilineTextAlignment(.center)
                .font(.title)
            Spacer()
        }.padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 32))
    }
}

struct HelpTitleView_Previews: PreviewProvider {
    static var previews: some View {
        HelpTitleView(title: "Preview")
    }
}
