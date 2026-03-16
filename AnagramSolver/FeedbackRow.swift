//
//  FeedbackRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 28/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct FeedbackRow: View {
    @State var aboutVM = AboutViewModel(ads: Ads())
    var body: some View {
        Button(action: aboutVM.feedback){
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
        .sheet(isPresented: $aboutVM.isMailVCPresented, content: {MailView(recipient: Strings.emailAddress, subject: Strings.feedbackSubject, result: self.$aboutVM.result)})
        .alert(isPresented: $aboutVM.showNoEmailAlert){
            Alert(title: Text("Email Not Supported"), message: Text("Please email me at: \(Strings.emailAddress)"), dismissButton: .default(Text("OK")))
        }
    }
}

struct FeedbackRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeedbackRow()
            FeedbackRow()
            FeedbackRow()
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
