//
//  UserGuideRow.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 04/02/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct UserGuideRow: View {
    var body: some View {
        Button(action: {UIApplication.shared.open(URL(string: Strings.userGuideURL)!, options: [:])}){
            HStack {
                Image(systemName: "info.circle")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.green)
                    .padding(8)
                VStack(alignment: .leading){
                    Text("User Guide").font(.title)
                    Text("Visit the online user guide for more in depth information ").font(.footnote)
                }
                Spacer()
            }
        }
    }
}

struct UserGuideRow_Previews: PreviewProvider {
    static var previews: some View {
        UserGuideRow()
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
