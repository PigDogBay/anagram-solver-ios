//
//  FiltersTests.swift
//  AnagramSolverTests
//
//  Created by Mark Bailey on 21/04/2026.
//  Copyright © 2026 MPD Bailey Technology. All rights reserved.
//

import Testing

struct FiltersTests {
    func makeSUT() -> Filters {
        return Filters()
    }
    
    @Test("Empty filters returns no descriptions")
    func emptyState() {
        let filters = makeSUT()
        #expect(filters.activeFiltersDescriptions().isEmpty)
    }

    @Test("Basic string filters append correct labels")
    func stringFilters() {
        let sut = makeSUT()
        sut.contains = "ABC"
        sut.containsWord = "Swift"
        
        let results = sut.activeFiltersDescriptions()
        
        #expect(results.contains("Contains letters ABC"))
        #expect(results.contains("Contains word Swift"))
    }
    
    @Test("Distinct selection logic", arguments: [
            (Filters.DISTINCT, "All letters are different"),
            (Filters.NOT_DISTINCT, "Some letters are the same")
        ])
    func distinctFilters(selection: Int, expectedLabel: String) {
        let sut = makeSUT()
        sut.distinctSelection = selection
        
        #expect(sut.activeFiltersDescriptions().contains(expectedLabel))
    }

    @Test("Prefix and Suffix toggle logic")
    func prefixSuffixLogic() {
        let sut = makeSUT()
        sut.prefix = "Start"
        sut.suffix = "End"
        
        // Test Enabled state
        sut.isStartingWithNotEnabled = false
        sut.isEndingWithNotEnabled = false
        #expect(sut.activeFiltersDescriptions().contains("Starting with Start"))
        #expect(sut.activeFiltersDescriptions().contains("Ending with End"))
        
        // Test Disabled state (The "Not " logic)
        sut.isStartingWithNotEnabled = true
        sut.isEndingWithNotEnabled = true
        #expect(sut.activeFiltersDescriptions().contains("Not starting with Start"))
        #expect(sut.activeFiltersDescriptions().contains("Not ending with End"))
    }

    @Test("Numeric filter limits")
    func numericFilters() {
        let sut = makeSUT()
        sut.moreThan = 5
        sut.lessThan = 10
        sut.equalTo = 7
        
        let results = sut.activeFiltersDescriptions()
        
        #expect(results.contains("More than 5 letters"))
        #expect(results.contains("Less than 10 letters"))
        #expect(results.contains("Equal to 7 letters"))
    }
    
}
