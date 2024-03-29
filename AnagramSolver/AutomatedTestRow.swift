//
//  AutomatedTestRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 14/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct AutomatedTestRow: View {
    var body: some View {
        Button(action: Coordinator.sharedInstance.autoTest){
            HStack {
                Image(systemName: "wand.and.stars")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.gray)
                    .padding(8)
                VStack(alignment: .leading){
                    Text("Auto Test").font(.title)
                    Text("Run the automated tests").font(.footnote)
                }
                Spacer()
            }
        }
    }
}
