//
//  HelpView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 24/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    
    @EnvironmentObject var coordinator : Coordinator
    @ObservedObject var viewModel = AboutViewModel()
    
    private var title : some View {
        HStack {
            Image("AboutIcon")
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(radius: 5)
            Text(Strings.appName)
                .font(.headline)
                .multilineTextAlignment(.center)
            Spacer()
        }

    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 8){
            title
            Text("Version v\(Strings.version)")
                .font(.body)
            Text(Strings.webAddress)
                .font(.body)
            Button(action: coordinator.sendFeedback){
                Text(Strings.emailAddress)
                    .font(.body)
                    .underline()
            }.buttonStyle(BorderlessButtonStyle())

            Text("©MPD Bailey Technology 2015")
                .font(.body)
        }
    }
    
    private var privatePolicySection : some View {
        VStack(alignment: .leading, spacing: 16){
            Text("PRIVACY POLICY")
                .font(.headline)
            Text("For information about how this app uses your data press the button below to review the Privacy Policy in full.")
                .font(.body)

            HStack {
                Spacer()
                Button(action: viewModel.showPrivacyPolicy){
                    Text("PRIVACY POLICY")
                        .modifier(AboutButtonMod())
                }.buttonStyle(BorderlessButtonStyle())
            }
        }
    }
    
    private var adsSection : some View {
        VStack(alignment: .leading, spacing: 16){
            Text("ADVERTISEMENTS")
                .font(.headline)
            Text("We care about your privacy and data security. We keep this app free by showing ads. Our ads are provided by Google Admob, click the link below for more information.")
                .font(.body)

            HStack {
                Spacer()
                Button(action: viewModel.showGooglePrivacyPolicy){
                    Text("FIND OUT MORE")
                        .modifier(AboutButtonMod())
                }.buttonStyle(BorderlessButtonStyle())
            }
            Text("This app will use your data to tailor ads to you. Our partners will collect data and use an unique identifier on your device to show you ads. You select here if we can continue to use your data to tailor ads for you.")
                .font(.body)
            Toggle(isOn: $coordinator.showMeRelevantAds) {
                if coordinator.showMeRelevantAds {
                    Text("Show me relevant ads")
                } else {
                    Text("Show me ads that are less relevant")
                }
            }
        }
    }
    private var helpOutSection : some View {
        VStack(alignment: .leading, spacing: 16){
            Text("HELP OUT")
                .font(.headline)
            Text("Keep updates coming by rating the app, your feedback is most welcome.")
                .font(.body)
            HStack {
                Spacer()
                Button(action: viewModel.rate){
                    Text("RATE")
                        .modifier(AboutButtonMod())
                }.buttonStyle(BorderlessButtonStyle())
                .padding(.leading, 16)
            }
        }
    }

    
    var body: some View {
        Form(){
            Group {
                infoSection
                privatePolicySection
                adsSection
                helpOutSection
            }.padding(.top, 16)
        }.navigationBarTitle(Text("About"), displayMode: .inline)
    }
}

struct AboutButtonMod : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundColor(.accentColor)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView().environmentObject(Coordinator(rootVC: RootViewController()))
    }
}
