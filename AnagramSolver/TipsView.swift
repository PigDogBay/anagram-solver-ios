//
//  TipsView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/02/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct TipsView: View {
    @ObservedObject var coordinator : Coordinator

    var body: some View {
        List {
            ForEach(tipsData) { tip in
                LinkedTipRow(coordinator: coordinator, viewModel: HelpViewModel(tip: tip))
            }
            NavigationLink(destination: FilterHelpView()){
                FilterRow()
            }
            NavigationLink(destination: DefintionHelpView()){
                DefinitionRow()
            }
            UserGuideRow()
            NavigationLink(destination: AboutView(coordinator: coordinator)){
                AboutRow()
            }
            SettingsRow()
            FeedbackRow(coordinator: coordinator)
            RateRow()
            TellFriendRow()
            #if DEBUG
            AutomatedTestRow(coordinator: coordinator)
            #endif
        }
        .padding(.leading,8)
        .padding(.trailing,8)
        .background(Color.init("navBackground"))
        .gesture(DragGesture().onChanged { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        })
    }
}

/*
 LinkedTipRow binds the TipRow and NavigationLink to showTip
 which allows TipRow to pop the view when the show me button is pressed.
 */
struct LinkedTipRow : View {
    let coordinator : Coordinator
    @ObservedObject var viewModel : HelpViewModel
    var body : some View {
        NavigationLink(destination: HelpView(coordinator: coordinator, viewModel: viewModel), isActive: $viewModel.showTip){
            TipRow(tip: viewModel.tip)
        }
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView(coordinator: Coordinator(rootVC: RootViewController()))
    }
}
