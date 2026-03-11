//
//  AppViewModel.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 10/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUtils
import SwiftUI

@MainActor
@Observable
class AppViewModel {
    @ObservationIgnored let settings = Settings()
}
