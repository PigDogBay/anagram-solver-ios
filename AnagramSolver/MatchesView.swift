//
//  MatchesView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 12/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUI
import SwiftUtils

struct MatchesView: View {
    @Environment(AppViewModel.self) var appVM
    @State var matchesVM : MatchesViewModel
    @State var isAdLoaded = false
    @State private var isShareOptionsPresented: Bool = false

    init(query: String, model: Model, filters: Filters) {
        // Use _matchesVM to initialize the @State property wrapper
        _matchesVM = State(initialValue: MatchesViewModel(query: query, model: model, filters: filters))
    }

    private func adSection() -> some View {
        HStack {
            let size = GADBannerViewController.getAdBannerSize()
            Spacer()
            GADBannerViewController(isAdLoaded: $isAdLoaded)
                .frame(
                    width: size.size.width,
                    height: isAdLoaded ? size.size.height : 0)
                .opacity(isAdLoaded ? 1 : 0)
                .offset(y: isAdLoaded ? 0 : 50)
                .animation(.easeInOut(duration: 0.5), value: isAdLoaded)
                .clipped()
            Spacer()
        }
    }

    private var listSection : some View {
        return List {
            status()
                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                    //Bug fix as separator starts at left hand side of the text
                    //So force the separator to start at the absolute edge (0) of the row
                    return 0
                }
            resultRows(matchesVM.matches, matchesVM.wordFormatter)
        }
        .padding(.top,-16)
        .listStyle(.insetGrouped)
        .scrollDismissesKeyboard(.immediately)
    }

    private var groupedByLengthSection : some View {
        return List {
            status()
            ForEach(matchesVM.grouped, id: \.self) { group in
                ExpandableSection(
                    isExpanded: true,
                    title: matchesVM.getSectionTitle(rows: group)) {
                        resultRows(group, self.matchesVM.wordFormatter)
                    }
            }
        }
        .padding(.top,-16)
        .listStyle(.sidebar)
        .tint(Color("accentColor")) //Need this for the section index
        .scrollDismissesKeyboard(.immediately)
    }

    private func resultRows(_ matches : [String], _ formatter : IWordFormatter) -> some View {
        ForEach(matches, id: \.self) { match in
            MatchRow(match: match, formatter: formatter, largeFont: matchesVM.settings.useLargeResultsFont)
                .contextMenu{
                    Button(action: {self.appVM.lookUpWord(word: match, provider: .Collins) }){Text("Collins")}
                    Button(action: {self.appVM.lookUpWord(word: match, provider: .Dictionary) }){Text("Dictionary.com")}
                    Button(action: {self.appVM.lookUpWord(word: match, provider: .GoogleDictionary) }){Text("Google Dictionary")}
                    Button(action: {self.appVM.lookUpWord(word: match, provider: .MerriamWebster) }){Text("Merriam-Webster")}
                    Button(action: {self.appVM.lookUpWord(word: match, provider: .MWThesaurus) }){Text("M-W Thesaurus")}
                    Button(action: {self.appVM.lookUpWord(word: match, provider: .Thesaurus) }){Text("Thesaurus.com")}
                    Button(action: {self.appVM.lookUpWord(word: match, provider: .Wiktionary) }){Text("Wiktionary")}
                    Button(action: {self.appVM.lookUpWord(word: match, provider: .Wikipedia) }){Text("Wikipedia")}
                    Button(action: {self.appVM.lookUpWord(word: match, provider: .WordGameDictionary) }){Text("Word Game Dictionary")}
                    Button(action: {self.matchesVM.search(word: match)}){Text("Search")}
                }
                .contentShape(Rectangle()) //Ensure row white space is tappable
                .onTapGesture {self.appVM.lookUpWord(word: match)}
        }
    }

    private func status() -> some View {
        HStack {
            Spacer()
            Text(matchesVM.status)
                .font(Font.body)
            Spacer()
            if matchesVM.showShareButton {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(Color("accentColor"))
                    .padding(.trailing,8)
                    .onTapGesture{
                        // Add a light haptic "click"
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        isShareOptionsPresented = true
                    }
            }
        }
    }

    var body: some View {
        VStack {
            switch matchesVM.resultsListMode {
            case .plain:
                listSection
            case .groupedByLength:
                groupedByLengthSection
            case .empty:
                listSection
            }
            if !appVM.settings.isProMode {
                adSection()
            }
        }
        .onAppear() {
            matchesVM.onAppear()
        }
        .navigationTitle("\(matchesVM.query)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarIconButton(placement: .topBarLeading, iconName: "chevron.left") {
                appVM.matchesExited(filters: matchesVM.filters)
            }
            ToolbarButton(placement: .topBarTrailing, label: "Filters"){
                appVM.goto(screen: .Filters)
            }
        }
        .sheet(isPresented: $isShareOptionsPresented){
            ActivityViewController(activityItems: matchesVM.share())
        }
    }
}

#Preview {
    MatchesView(
        query: "preview",
        model: Model(),
        filters: Filters()
    )
}
