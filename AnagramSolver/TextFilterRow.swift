//
//  TextFilterRow.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 16/06/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct TextFilterRow : View {
    let label : String
    let hint : String
    @Binding var text : String
    
    var body: some View {
        HStack {
            Text(label)
            TextField(hint, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .modifier(EmailKeyboardMod())
        }
    }
}
