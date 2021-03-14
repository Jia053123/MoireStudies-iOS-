//
//  MockMoireViewController.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-08.
//

@testable import MoireStudies
import Foundation
import UIKit

class MockMoireViewController: MoireViewController {
    private(set) var currentPatterns: Array<Pattern>?
    private(set) var setUpPerformed: Bool = false
    private(set) var resetPerformed: Bool = false
    private(set) var highlightedPatternIndexes: Set<Int> = []
    private(set) var unhighlightedPatternIndexes: Set<Int> = []
    private(set) var dimmedPatternIndexes: Set<Int> = []
    private(set) var patternsUndimmed: Bool = false
    private(set) var hiddenPatternIndexes: Set<Int> = []
    private(set) var unhiddenPatternIndexes: Set<Int> = []
    
    func resetTestingRecords() {
        self.currentPatterns = nil
        self.setUpPerformed = false
        self.resetPerformed = false
        self.patternsUndimmed = false
    }
    
    override func setUp(patterns: Array<Pattern>, settings: InitSettings) {
        super.setUp(patterns: patterns, settings: settings)
        self.setUpPerformed = true
        self.currentPatterns = patterns
    }
    
    override func resetMoireView(patterns: Array<Pattern>, settings: InitSettings) {
        super.resetMoireView(patterns: patterns, settings: settings)
        self.resetPerformed = true
        self.currentPatterns = patterns
    }
    
    override func highlightPatternView(patternViewIndex: Int) {
        super.highlightPatternView(patternViewIndex: patternViewIndex)
        self.highlightedPatternIndexes.insert(patternViewIndex)
    }
    
    override func unhighlightPatternView(patternViewIndex: Int) {
        super.unhighlightPatternView(patternViewIndex: patternViewIndex)
        self.unhighlightedPatternIndexes.insert(patternViewIndex)
    }
    
    override func dimPatternView(patternViewIndex: Int) {
        super.dimPatternView(patternViewIndex: patternViewIndex)
        self.dimmedPatternIndexes.insert(patternViewIndex)
    }
    
    override func undimPatternViews() {
        super.undimPatternViews()
        self.patternsUndimmed = true
    }
    
    override func hidePatternView(patternViewIndex: Int) {
        super.hidePatternView(patternViewIndex: patternViewIndex)
        self.hiddenPatternIndexes.insert(patternViewIndex)
    }
    
    override func unhidePatternView(patternViewIndex: Int) {
        super.unhidePatternView(patternViewIndex: patternViewIndex)
        self.unhiddenPatternIndexes.insert(patternViewIndex)
    }
    
    override func modifyPatternView(patternViewIndex: Int, newPattern: Pattern) {
        super.modifyPatternView(patternViewIndex: patternViewIndex, newPattern: newPattern)
        self.currentPatterns?[patternViewIndex] = newPattern
    }
}
