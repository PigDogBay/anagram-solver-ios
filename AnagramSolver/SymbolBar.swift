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
    let haptic = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        if #available(iOS 26.0, *) {
            return glassBar
                .glassEffect()
        } else {
            return ultraThinBar
        }

    }
    
    private var glassBar : some View {
        HStack(spacing: 0) {
            ForEach(searchBarVM.symbols, id: \.0) { char, icon in
                Button {
                    haptic.impactOccurred()
                    searchBarVM.append(symbol: char)
                } label: {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("accentColor"))
                        .padding(.horizontal,12)
                        .padding(.vertical,6)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 25)
    }
    
    //Simulates glass effect using ultraThinMaterial, shadow and border
    private var ultraThinBar : some View {
        HStack(spacing: 25) {
            ForEach(searchBarVM.symbols, id: \.0) { char, icon in
                Button {
                    haptic.impactOccurred()
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
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(.white.opacity(0.2), lineWidth: 0.5) // Subtle border for depth
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)

    }

}
