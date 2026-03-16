//
//  TipsView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 03/02/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI
import SwiftUtils

struct TipsView: View {
    @State var searchHistoryVM : SearchHistoryRowViewModel
    @Environment(StoreViewModel.self) var storeVM

    init(searchHistoryVM: SearchHistoryRowViewModel) {
        self.searchHistoryVM = searchHistoryVM
    }

    private func tip(_ tipData : Tip) -> some View {
        LinkedTipRow(tip: tipData)
    }
    
    var body: some View {
        List {
            Group {
                tip(anagramTip)
                tip(blankLettersTip)
                tip(twoWordAnagramTip)
                if searchHistoryVM.showHistory{
                    NavigationLink(value: NavigationScreens.SearchHistory){
                        HelpRow(iconName: "fossil.shell", colorName: "iconBlue", title: "History", subTitle: "View your previous searches")
                    }
                }
                NavigationLink(value: NavigationScreens.DefinitionHelp){
                    HelpRow(iconName: "book", colorName: "iconBlue", title: "Definitions", subTitle: "Tap on a result to look it up")
                }
            }
            Group {
                tip(crosswordTip)
                tip(phraseTip)
                tip(shortcutsTip)
                NavigationLink(value: NavigationScreens.FiltersHelp){
                    HelpRow(iconName: "line.3.horizontal.decrease.circle", colorName: "iconRed", title: "Filters", subTitle: "Too many matches? Refine your search!")
                }
                NavigationLink(value: NavigationScreens.RemoveAdsDetail){
                    RemoveAdsRow(storeVM: storeVM)
                 }
                tip(spellingBeeTip)
                tip(codewordsTip)
                
                NavigationLink(value: NavigationScreens.SettingsHelp){
                    HelpRow(iconName: "gear", colorName: "iconGreen", title: "Settings", subTitle: "Change the word list and more")
                }
            }
            
            Group {
                tip(supergramsTip)
                tip(prefixSuffixTip)
//                NavigationLink(destination: AboutView()){
//                    AboutRow()
//                }
                UserGuideRow()
                FeedbackRow()
                RateRow()
                TellFriendRow()
            }
            #if DEBUG
            AutomatedTestRow()
            #endif
        }
        .onAppear{
            searchHistoryVM.onAppear()
        }
        .listStyle(.plain)
        .padding(.leading,0)
        .padding(.trailing,0)
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
    let tip : Tip
    var body : some View {
        NavigationLink(value: NavigationScreens.Tip(tip)){
            HelpRow(
                iconName: "questionmark.circle",
                colorName: "iconYellow",
                title: tip.title,
                subTitle: tip.subtitle)
        }
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView(searchHistoryVM: SearchHistoryRowViewModel(
            SearchHistoryModel(persistence: SearchHistoryUserDefaults())
        ))
    }
}
