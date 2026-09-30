//
//  RandomTextSelection.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 30/09/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//
import SwiftUI

extension String {
    /// Generates a valid random `TextSelection` for the current string.
    func mpdbRandomTextSelection() -> TextSelection {
        guard !isEmpty else {
            let zeroRange = startIndex..<startIndex
            return TextSelection(range: zeroRange)
        }
        
        // Collect all valid index boundaries, including `endIndex`
        let indicesArray = Array(indices) + [endIndex]
        let idx1 = indicesArray.randomElement()!
        let idx2 = indicesArray.randomElement()!
        let lower = min(idx1, idx2)
        let upper = max(idx1, idx2)
        
        // Generate a single selection range (can be insertion point if empty)
        return TextSelection(range: lower..<upper)
    }
}
