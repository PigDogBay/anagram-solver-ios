//
//  HelpView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 24/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    
    @ObservedObject var coordinator : Coordinator
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
                    .foregroundColor(Color("materialButton"))
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
    
    private var adPersonalizeButton : some View {
        Toggle(isOn: $viewModel.showMeRelevantAds) {
            if viewModel.showMeRelevantAds {
                Text("Show me relevant ads")
            } else {
                Text("Show me ads that are less relevant")
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
            Text("You may remove advertisements by making a one off in app purchase.")
            HStack {
                Spacer()
                Button(action: viewModel.buy){
                    Text(viewModel.buyButtonText)
                        .modifier(AboutButtonMod())
                }.buttonStyle(BorderlessButtonStyle())
                .disabled(!viewModel.buyButtonEnabled)
            }
            Text("If you have already purchased the option to remove ads, press the restore button below to retrieve your purchase details.")
            HStack {
                Spacer()
                Button(action: viewModel.restorePurchase){
                    Text("RESTORE PURCHASE")
                        .modifier(AboutButtonMod())
                }.buttonStyle(BorderlessButtonStyle())
            }
            Text("This app will use your data to tailor ads to you. Our partners will collect data and use an unique identifier on your device to show you ads. You select here if we can continue to use your data to tailor ads for you.")
                .font(.body)
            if #available(iOS 14.0, *) {
                adPersonalizeButton.toggleStyle(SwitchToggleStyle(tint: Color("accentColor")))
            } else {
                adPersonalizeButton
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
                Button(action: coordinator.sendFeedback){
                    Text("FEEDBACK")
                        .modifier(AboutButtonMod())
                }.buttonStyle(BorderlessButtonStyle())
                .padding(.leading, 16)
                Button(action: AboutViewModel.rate){
                    Text("RATE")
                        .modifier(AboutButtonMod())
                }.buttonStyle(BorderlessButtonStyle())
                .padding(.leading, 16)
            }.padding(.bottom, 16)
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
            .alert(isPresented: $viewModel.showAlertRestored){
                Alert(title: Text("Purchase Restored"), message: Text("Your purchase has been restored, Ads have now been removed"), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $viewModel.showAlertFailed){
                Alert(title: Text("Purchase Failed"), message: Text("Sorry, unable to complete the purchase. You have not been charged."), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear{viewModel.onAppear()}
        .onDisappear{viewModel.onDisappear()}
        .navigationBarTitle(Text("About"), displayMode: .inline)
    }
}

struct AboutButtonMod : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote.bold())
            .foregroundColor(Color("materialButton"))
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(coordinator: Coordinator())
    }
}
