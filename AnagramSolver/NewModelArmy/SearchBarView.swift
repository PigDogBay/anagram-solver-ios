//
//  SearchBarView.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 11/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//
import SwiftUI

struct SearchBarView : View {
    @FocusState private var isFocused: Bool
    
    @State var searchBarVM : SearchBarViewModel
    
    var body: some View {
        return TextField("Enter letters", text: $searchBarVM.query)
            .onChange(of: searchBarVM.query){ oldValue, newValue in
                if (oldValue != newValue) {
                    searchBarVM.updateQuery(newValue)
                }
            }
            .modifier(SearchBarMod())
            .focused($isFocused)
            .onAppear(){
                isFocused = Settings().showKeyboard
            }
    }
}

struct SearchBarMod : ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled()
            .accessibilityIdentifier("searchTextField")
            .padding(.leading,8)
            .padding(.trailing,8)
            .padding(.top,6)
            .padding(.bottom,6)
            .background(Color("queryBackground"))
            .padding(6)
            .background(Color("navBackground"))
            .textFieldStyle(PlainTextFieldStyle())
            .modifier(EmailKeyboardMod(textStyle: .title))
            .submitLabel(.search)

    }
}
struct EmailKeyboardMod : ViewModifier {
    
    @Environment(AppViewModel.self) var coordinator
    let settings = Settings()
    private let textStyle : Font.TextStyle

    private var autoCap : UITextAutocapitalizationType {
        return settings.useUpperCase ? .allCharacters : .none
    }
    
    private var keyboardType : UIKeyboardType {
        return settings.keyboardType == Settings.keyboardWebSearch ? .webSearch : .emailAddress
    }
    
    private var fontDesign : Font.Design {
        settings.useMonospacedFont ? .monospaced : .default
    }
    
    init(textStyle : Font.TextStyle = .body){
        self.textStyle = textStyle
    }

    func body(content: Content) -> some View {
        content
            .accentColor(Color("accentColor")) //Set cursor color
            .font(.system(textStyle, design: fontDesign))
            .keyboardType(keyboardType)
            .textContentType(UITextContentType(rawValue: "")) //Prevent email addresses being shown
            .disableAutocorrection(true)
            .autocapitalization(autoCap)
    }
}
