//
//  ListPicker.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 19/08/2021.
//  Copyright © 2021 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct SettingsPicker: View {
    let label : String
    let titles : [String]
    let values : [String]
    @Binding var selection : String

    var body: some View {
        Picker(selection: $selection, label: Text(label)){
            ForEach(0 ..< values.count, id: \.self){
                Text(self.titles[$0]).tag(self.values[$0])
            }
        }
    }
}
