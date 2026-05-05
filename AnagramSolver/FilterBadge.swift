//
//  FilterBadge.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 05/05/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct FilterBadgeModifier: ViewModifier {
    let isShowing: Bool

    func body(content: Content) -> some View {
        content
            .badge(
                isShowing ?
                Text(Image(systemName: "checkmark"))
                    .foregroundColor(Color("accentColor"))
                : nil
            )
    }
}

extension View {
    /// Applies a checkmark badge if the condition is met.
    func filterBadge(show: Bool) -> some View {
        self.modifier(FilterBadgeModifier(isShowing: show))
    }
}
