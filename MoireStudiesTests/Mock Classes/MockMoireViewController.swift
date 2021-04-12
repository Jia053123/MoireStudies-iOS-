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
    
    override func setUp(patterns: Array<Pattern>, configs: Configurations) {
        self.setUpPerformed = true
        self.currentPatterns = patterns
    }
    
    override func resetMoireView(patterns: Array<Pattern>, configs: Configurations) {
        self.resetPerformed = true
        self.currentPatterns = patterns
    }
    
    override func highlightPatternView(patternViewIndex: Int) {
        self.highlightedPatternIndexes.insert(patternViewIndex)
    }
    
    override func unhighlightPatternView(patternViewIndex: Int) {
        self.unhighlightedPatternIndexes.insert(patternViewIndex)
    }
    
    override func dimPatternView(patternViewIndex: Int) {
        self.dimmedPatternIndexes.insert(patternViewIndex)
    }
    
    override func undimPatternViews() {
        self.patternsUndimmed = true
    }
    
    override func hidePatternView(patternViewIndex: Int) {
        self.hiddenPatternIndexes.insert(patternViewIndex)
    }
    
    override func unhidePatternView(patternViewIndex: Int) {
        self.unhiddenPatternIndexes.insert(patternViewIndex)
    }
    
    override func modifyPatternView(patternViewIndex: Int, newPattern: Pattern) {
        self.currentPatterns?[patternViewIndex] = newPattern
    }
}
