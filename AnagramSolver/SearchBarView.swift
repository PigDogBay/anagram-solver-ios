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
    @Environment(AppViewModel.self) var appVM

    var body: some View {
        return TextField("Enter letters", text: $searchBarVM.query)
            .onChange(of: searchBarVM.query){ oldValue, newValue in
                if (oldValue != newValue) {
                    searchBarVM.updateQuery(newValue)
                }
            }
            .onSubmit {
                if searchBarVM.isValid() {
                    appVM.search()
                } else {
                    searchBarVM.showValidationError = true
                }
            }
            .modifier(SearchBarMod())
            .focused($isFocused)
            .onAppear(){
                isFocused = Settings().showKeyboard
            }
            .alert(isPresented: $searchBarVM.showValidationError){
                Alert(
                    title: Text("Search Error"),
                    message: Text("Please enter a valid query"),
                    dismissButton: .default(Text("OK")
                ))
            }

    }
}

struct SearchBarMod : ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled()
            .accessibilityIdentifier("searchTextField")
            .frame(height: 44)
            .padding(.leading,8)
            .padding(.trailing,8)
            .padding(.top,3)
            .padding(.bottom,3)
            .background(Color("queryBackground"))
            .padding(8)
            .background(Color("navBackground"))
            .textFieldStyle(.plain)
            .modifier(EmailKeyboardMod(textStyle: .title))
            .submitLabel(.search)

    }
}
struct EmailKeyboardMod : ViewModifier {
    
    @AppStorage(Keys.useUpperCase) var useUpperCase: Bool = Settings().useUpperCase
    @AppStorage(Keys.keyboardType) var keyboardName : String = Settings().keyboardType
    @AppStorage(Keys.useMonospacedFont) var useMonospacedFont : Bool = Settings().useMonospacedFont

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
