//
//  SymbolBar.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 23/04/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//
import SwiftUI

struct SymbolBar : View {
    @State var searchBarVM : SearchBarViewModel

    var body: some View {
        return HStack(spacing: 25) {
            ForEach(searchBarVM.symbols, id: \.0) { char, icon in
                Button {
                    searchBarVM.append(symbol: char)
                } label: {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("accentColor"))
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 25)
        .background(.ultraThinMaterial) // The "Glass" effect
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(.white.opacity(0.2), lineWidth: 0.5) // Subtle border for depth
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
    }

}
