# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Layout

This repo is the SwiftUI iOS app (Anagram Solver by MPD Bailey Technology). It builds together with a sibling git repo, `../SwiftUtils/` — a shared framework (also used by other MPDB word apps, e.g. Crossword Solver King) holding the search engine, word lists, Nabu definitions/synonyms DB, IAP, ratings and speech helpers.

`AnagramSolver.xcworkspace` references `../SwiftUtils/SwiftUtils.xcodeproj` by relative path, so both repos must stay side by side. Search/parsing behaviour changes usually belong in `SwiftUtils`; commit in the repo you changed.

## Build & test

Always build through the workspace. Google Mobile Ads and UMP come in via Swift Package Manager (pinned in `AnagramSolver.xcworkspace/xcshareddata/swiftpm/Package.resolved`); the app target needs `-ObjC` in Other Linker Flags for them. Run commands from this repo's root.

```sh
DEST='platform=iOS Simulator,name=iPhone 18 Pro'

# Build the app
xcodebuild -workspace AnagramSolver.xcworkspace -scheme AnagramSolver -destination "$DEST" build

# App unit tests / UI tests
xcodebuild -workspace AnagramSolver.xcworkspace -scheme AnagramSolverTests -destination "$DEST" test
xcodebuild -workspace AnagramSolver.xcworkspace -scheme AnagramSolverUITests -destination "$DEST" test

# SwiftUtils tests
xcodebuild -workspace AnagramSolver.xcworkspace -scheme SwiftUtilsTests -destination "$DEST" test

# Single test (XCTest: Target/Class/method; Swift Testing: Target/Suite/func())
xcodebuild ... test -only-testing:AnagramSolverTests/WordEngineTests/removeDuplicates1()
xcodebuild ... test -only-testing:SwiftUtilsTests/SearchParserTests
```

Tests are a mix of XCTest and Swift Testing (`import Testing`, `@Suite`/`@Test`/`#expect`). Some tests load real bundled word lists (e.g. `"words"`), so they are slow-ish and depend on the resource files. UI tests drive the real app (search via soft keyboard, `SEARCH_TIMEOUT` 15s) and reset settings via the in-app "Reset Settings" dialog.

## App architecture (`AnagramSolver/`)

- **Entry**: `AnagramSolver.swift` (`@main`) creates `AppViewModel`, `StoreViewModel`, `SpeechManager` and injects them via `.environment(...)`. A SwiftData `ModelContainer` persists a single `Filters` record (seeded on first launch). `AppDelegate` (via `@UIApplicationDelegateAdaptor`) sets UIKit appearance and registers `UserDefaults` defaults.
- **Navigation**: `RootView` owns a `NavigationStack` bound to `AppViewModel.path`; every screen is a case of `NavigationScreens`. Navigate with `appVM.goto(screen:)` / `appVM.goBack()` — not `@Environment(\.dismiss)`. `RootView` fetches `Filters` manually in `onAppear` (deliberately not `@Query`, to avoid re-render on every filter change).
- **State machine**: `Model.appState` (`AppStates`: uninitialized → loading → ready → searching → finished/cancelled, or error) drives the UI. `AppViewModel.canSearch()`, `MatchesViewModel.onAppear()` and the error alert all key off it; `Model.onStateChange` exists so `AutoTest` (a random-query soak test triggered from the UI) can follow state.
- **Search engine**: `Model/WordEngine.swift` wraps SwiftUtils' `WordSearch` (word list + phrases) and `NabuSearch`/`NabuLookUp` (synonyms/definitions from bundled `nabu.db`). Searches run on a background queue; results arrive via the `WordListCallback.update(_:)` into `working`/`synonymWorking`. Cancellation uses `AtomicBool` + `wordSearch.stop()`; `resultsLimit` also stops the search. Queries are parsed by `SearchParser` into a `SearchQuery` (anagram, two-word anagram, crossword pattern, etc.).
- **Word lists**: bundled `.txt` files (`small`, `game`, `twl`, `sowpods`, `words`, `wordlist-de/es/fr/it/pt`, plus `phrases`). Selectable lists are defined by parallel arrays `Settings.wordListTitles` / `Settings.wordListValues` — keep them in sync when adding one.
- **Settings**: `Model/Settings.swift` is a `UserDefaults` wrapper; key names live in `Keys`, defaults in `registerDefaultSettings()`. Some views read the same keys via `@AppStorage(Keys.…)`. `Settings.bundle` is the iOS Settings-app plist (acknowledgements/privacy). After settings change, `AppViewModel.settingsExited` re-applies them to the engine and reloads the word list if needed.
- **Monetisation**: Google Mobile Ads (`Ads.swift`, `GADBannerViewController`, UMP consent via `FormViewControllerRepresentable`) is skipped when `settings.isProMode`. The "Remove Ads" IAP is handled by `StoreViewModel` on top of SwiftUtils' IAP types; `InAppPurchaseStore.storekit` is the local StoreKit config for testing.
- Views are small SwiftUI files at the top level; view models (`@Observable`, `@MainActor`) are in `Model/`. Many files carry headers from older apps/eras (`NMA…`, `CrosswordSolverKing`) — the code was migrated from UIKit to SwiftUI in 2026.
