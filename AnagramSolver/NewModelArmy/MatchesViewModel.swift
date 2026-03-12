//
//  MatchesViewModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 12/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//


import SwiftUI

@Observable class MatchesViewModel {
    var query : String
    
    init(query: String) {
        print("MatchesVM init()")
        self.query = query
    }
}
