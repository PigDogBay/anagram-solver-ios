//
//  ExpandableSection.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 05/02/2026.
//  Copyright © 2026 Mark Bailey. All rights reserved.
//


import SwiftUI

///Displays a collapsible section in a list
///For use inside List{}.listStyle(.sidebar), .sidebar will show the disclosure icon toggle
struct ExpandableSection<Content : View> : View {
    
    @State private var isExpanded : Bool
    let title : String
    let content : Content
    
    init(isExpanded : Bool, title: String, @ViewBuilder content: () -> Content) {
        self.isExpanded = isExpanded
        self.title = title
        self.content = content()
    }

    var body: some View {
        Section(
            isExpanded: $isExpanded,
            content: {
                self.content
            },
            header: {
                Text(title)
            }
        )
    }
}

struct SectionIndexModifier : ViewModifier {
    let title : String
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .sectionIndexLabel(title)
        } else {
            // Fallback on earlier versions
            content
        }
    }
}
