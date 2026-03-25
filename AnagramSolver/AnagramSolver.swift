//
//  AnagramSolver.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 10/03/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import SwiftUI
import SwiftUtils
import SwiftData
import AVFoundation

@main
struct AnagramSolverApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var appVM = AppViewModel()
    @State private var storeVM = StoreViewModel(productID: REMOVE_ADS_PRODUCT_ID)
    @State private var speech = SpeechManager()
    
    @State private var container: ModelContainer

    @AppStorage(Keys.darkModeOverride) var darkModeOverride: String = Settings.darkModeValueSystem
    
    init(){
        //Set up SwiftData
        do {
            let config = ModelConfiguration(for: Filters.self)
            let container = try ModelContainer(for: Filters.self, configurations: config)
            self._container = State(initialValue: container)
            ensureDefaultFilters(in: container)
        } catch {
            fatalError("Could not initialize SwiftData: \(error)")
        }
    }
    
    //Set up initial container data
    @MainActor
    private func ensureDefaultFilters(in container: ModelContainer) {
        let context = container.mainContext
        let descriptor = FetchDescriptor<Filters>()
        
        do {
            let existingCount = try context.fetchCount(descriptor)
            if existingCount == 0 {
                let defaultFilters = Filters()
                context.insert(defaultFilters)
                try context.save()
            }
        } catch {
            print("Failed to seed default filters: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appVM)
                .environment(storeVM)
                .environment(speech)
                .modelContainer(for: [Filters.self])
                // Dark Mode handling
                .preferredColorScheme(getPreferredColorScheme())
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    switch newPhase {
                    case .inactive:
                        appVM.onResignActive()
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
