//
//  ToolbarButton.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 26/01/2026.
//  Copyright © 2026 Mark Bailey. All rights reserved.
//
/*
 The glass effect doesn't look great in light mode due to the grey background colour of the navigation bar
 So these custom tool bar buttons remove the glass effect for iOS 26 and above
 
 */
import SwiftUI

struct ToolbarButton : ToolbarContent {
    let placement : ToolbarItemPlacement
    let label : String
    let action: () -> Void

    var body : some ToolbarContent {
        if #available(iOS 26.0, *) {
            return ToolbarItem(placement: placement) {
                Button(action: action) {
                    Text(label)
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("\(label)Button")
                }
            }.sharedBackgroundVisibility(.hidden)
        } else {
            return ToolbarItem(placement: placement) {
                Button(action: action) {
                    Text(label)
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("\(label)Button")
                }
            }
        }
    }
}

struct ToolbarIconButton : ToolbarContent {
    let placement : ToolbarItemPlacement
    let iconName : String
    let action: () -> Void

    var body : some ToolbarContent {
        if #available(iOS 26.0, *) {
            return ToolbarItem(placement: placement) {
                Button(action: action) {
                    Image(systemName: iconName)
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("\(iconName)Button")
                }
            }.sharedBackgroundVisibility(.hidden)
        } else {
            return ToolbarItem(placement: placement) {
                Button(action: action) {
                    Image(systemName: iconName)
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("\(iconName)Button")
                }
            }
        }
    }
}
