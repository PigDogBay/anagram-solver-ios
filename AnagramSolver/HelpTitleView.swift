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
    let icon : String
    
    init(title: String, icon : String = "lightbulb_on"){
        self.title = title
        self.icon = icon
    }
    
    var body: some View {
        HStack{
            Spacer()
            Image(icon)
                .padding(8)
            Text(title)
                .multilineTextAlignment(.center)
                .font(.title)
            Spacer()
        }.padding(EdgeInsets(top: 16, leading: -32, bottom: 0, trailing: 8))
    }
}

struct HelpTitleView_Previews: PreviewProvider {
    static var previews: some View {
        HelpTitleView(title: "Preview")
    }
}
