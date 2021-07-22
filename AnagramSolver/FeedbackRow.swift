//
//  FeedbackRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 28/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct FeedbackRow: View {
    @ObservedObject var coordinator : Coordinator
    
    var body: some View {
        Button(action: coordinator.sendFeedback){
            HStack {
                Image(systemName: "envelope")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.red)
                    .padding(8)
                VStack(alignment: .leading){
                    Text("Feedback").font(.title)
                    Text("Email your suggestions and ideas").font(.footnote)
                }
                Spacer()
            }
        }
    }
}

struct FeedbackRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeedbackRow(coordinator: Coordinator())
            FeedbackRow(coordinator: Coordinator())
            FeedbackRow(coordinator: Coordinator())
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
