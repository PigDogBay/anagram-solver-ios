//
//  SettingsView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 18/08/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    private let coordinator = Coordinator.sharedInstance
    @ObservedObject var viewModel = SettingsViewModel()
    
    private var tipsToggle : some View {
        Toggle(isOn: $viewModel.showCardTips) {
            if viewModel.showCardTips {
                Text("Show tips as cards")
            } else {
                Text("Show tips as a list")
            }
        }
    }
    var body: some View {
        Form {
            Section(header: Text("Display"),
                    footer: Text("Blah blah")){
                if #available(iOS 14.0, *) {
                    tipsToggle
                        .toggleStyle(SwitchToggleStyle(tint: Color("materialButton")))
                } else {
                    tipsToggle
                }
            }
        }.navigationBarTitle(Text("Settings"), displayMode: .inline)
        .onDisappear(){
            coordinator.updateSettings()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
