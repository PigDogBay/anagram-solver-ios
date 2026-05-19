//
//  Keyboard.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 25/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

struct Keyboard {
    let settings = Settings()
    
    /// Converts typed spaces and . to ? for the crossword pattern filter
    /// - Parameter typed: typed chars in the crossword pattern text field
    func crossword(typed : String) -> String{
        // Convert ellipsis back to three periods
        var query = typed.replacingOccurrences(of: "…", with: "...")
        if settings.spaceToQuestionMark {
            query = query.replacingOccurrences(of: " ", with: "?")
        }
        if settings.fullStopToQuestionMark {
            query = query.replacingOccurrences(of: ".", with: "?")
        }
        return query
    }

    func regEx(typed : String) -> String{
        // Convert ellipsis back to three periods
        return typed.replacingOccurrences(of: "…", with: "...")
    }

}
