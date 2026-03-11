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
            .padding(.top,8)
            .padding(.bottom,8)
            .background(Color("queryBackground"))
            .padding(8)
            .background(Color("navBackground"))
            .textFieldStyle(PlainTextFieldStyle())
            .modifier(EmailKeyboardMod(textStyle: .title))
            .submitLabel(.search)

    }
}
struct EmailKeyboardMod : ViewModifier {
    
    @AppStorage(Keys.useUpperCase) var useUpperCase: Bool = Settings().useUpperCase
    @AppStorage(Keys.keyboardType) var keyboardName : String = Settings().keyboardType
    @AppStorage(Keys.useMonospacedFont) var useMonospacedFont : Bool = Settings().useMonospacedFont

    @Environment(AppViewModel.self) var coordinator
    private let textStyle : Font.TextStyle

    private var autoCap : UITextAutocapitalizationType {
        return useUpperCase ? .allCharacters : .none
    }
    
    private var keyboardType : UIKeyboardType {
        return keyboardName == Settings.keyboardWebSearch ? .webSearch : .emailAddress
    }
    
    private var fontDesign : Font.Design {
        useMonospacedFont ? .monospaced : .default
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
