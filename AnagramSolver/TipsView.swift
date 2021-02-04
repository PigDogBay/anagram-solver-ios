//
//  TipsView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/02/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct TipsView: View {
    @EnvironmentObject var coordinator : Coordinator

    var body: some View {
        List {
            ForEach(tipsData) { tip in
                LinkedTipRow(viewModel: HelpViewModel(tip: tip))
            }
            NavigationLink(destination: FilterHelpView()){
                FilterRow()
            }
            NavigationLink(destination: DefintionHelpView()){
                DefinitionRow()
            }
            UserGuideRow()
            NavigationLink(destination: AboutView().environmentObject(coordinator)){
                AboutRow()
            }
            SettingsRow()
            FeedbackRow()
            RateRow()
            TellFriendRow()
//            AutomatedTestRow()
        }.gesture(DragGesture().onChanged { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        })
    }
}

/*
 LinkedTipRow binds the TipRow and NavigationLink to showTip
 which allows TipRow to pop the view when the show me button is pressed.
 */
struct LinkedTipRow : View {
    @ObservedObject var viewModel : HelpViewModel
    var body : some View {
        NavigationLink(destination: HelpView(viewModel: viewModel), isActive: $viewModel.showTip){
            TipRow(tip: viewModel.tip)
        }
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView().environmentObject(Coordinator(rootVC: RootViewController()))
    }
}
