//
//  SymbolBar.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 23/04/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//
import SwiftUI

struct SymbolBar : View {
    var searchBarVM : SearchBarViewModel
    let haptic = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        HStack(spacing: 0) {
            ForEach(searchBarVM.symbols, id: \.0) { char, icon in
                Button {
                    haptic.impactOccurred()
                    searchBarVM.insert(symbol: char)
                } label: {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("accentColor"))
                        .padding(.horizontal,12)
                        .padding(.vertical,8)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier(char)
            }
        }
        .padding(.horizontal, 12)
    }
}
