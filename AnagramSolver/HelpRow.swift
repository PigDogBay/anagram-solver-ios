//
//  HelpRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 19/05/2022.
//  Copyright © 2022 Mark Bailey. All rights reserved.
//

import SwiftUI

struct HelpRow: View {
    let iconName : String
    let colorName : String
    let title : String
    let subTitle : String
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(Font.system(.largeTitle))
                .foregroundColor(Color(colorName))
                .padding(4)
            VStack(alignment: .leading){
                Text(title).font(.title)
                Text(subTitle).font(.footnote)
            }
            Spacer()
        }
    }
}

struct HelpRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HelpRow(iconName: "lightbulb", colorName: "iconYellow", title: "Preview", subTitle: "This is a preview for the help row")
        }
       .previewLayout(.fixed(width: 300, height: 70))
    }
}
