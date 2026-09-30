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
    func randomTextSelection() -> TextSelection {
        guard !isEmpty else {
            let zeroRange = startIndex..<startIndex
            return TextSelection(range: zeroRange)
        }
        
        // Collect all valid index boundaries, including `endIndex`
        let indicesArray = Array(indices) + [endIndex]
        
        // Helper to pick a valid random Range<String.Index>
        func randomRange() -> Range<String.Index> {
            let idx1 = indicesArray.randomElement()!
            let idx2 = indicesArray.randomElement()!
            
            let lower = min(idx1, idx2)
            let upper = max(idx1, idx2)
            
            return lower..<upper
        }
        
        // Randomly test multi-selection vs. single selection
        let shouldBeMultiSelection = Bool.random()
        
        if shouldBeMultiSelection {
            // Generate 1 to 3 random ranges and insert into a RangeSet
            let rangeCount = Int.random(in: 1...3)
            var rangeSet = RangeSet<String.Index>()
            for _ in 0..<rangeCount {
                rangeSet.insert(contentsOf: randomRange())
            }
            return TextSelection(ranges: rangeSet)
        } else {
            // Generate a single selection range (can be insertion point if empty)
            return TextSelection(range: randomRange())
        }
    }
}
