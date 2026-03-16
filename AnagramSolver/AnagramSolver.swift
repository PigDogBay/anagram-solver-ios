//
//  AnagramSolver.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 10/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

@main
struct AnagramSolverApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var appViewModel = AppViewModel()
    @State private var filtersViewModel = FiltersViewModel()
    
    @AppStorage(Keys.darkModeOverride) var darkModeOverride: String = Settings.darkModeValueSystem

    var body: some Scene {
        WindowGroup {
            NMARootView()
                .environment(appViewModel)
                .environment(filtersViewModel)
                // Dark Mode handling
                .preferredColorScheme(getPreferredColorScheme())
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    switch newPhase {
                    case .inactive:
                        appViewModel.onResignActive()
                    case .background: break
                    case .active: break
                    @unknown default:
                        break
                    }
                }
        }
    }
    
    private func getPreferredColorScheme() -> ColorScheme? {
        switch (darkModeOverride){
        case Settings.darkModeValueLight: return .light
        case Settings.darkModeValueDark: return .dark
        default: return .none
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}
