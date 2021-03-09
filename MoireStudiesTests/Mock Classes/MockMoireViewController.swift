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
    private(set) var highlightedPatternIndex: Int?
    private(set) var unhighlightedPatternIndex: Int?
    private(set) var dimmedPatternIndex: Int?
    private(set) var patternsUndimmed: Bool = false
    private(set) var hiddenPatternIndex: Int?
    private(set) var unhiddenPatternIndex: Int?
    
    func resetTestingRecords() {
        self.currentPatterns = nil
        self.setUpPerformed = false
        self.resetPerformed = false
        self.highlightedPatternIndex = nil
        self.unhighlightedPatternIndex = nil
        self.dimmedPatternIndex = nil
        self.patternsUndimmed = false
        self.hiddenPatternIndex = nil
        self.unhiddenPatternIndex = nil
    }
    
    override func setUp(patterns: Array<Pattern>, settings: InitSettings) {
        super.setUp(patterns: patterns, settings: settings)
        self.setUpPerformed = true
    }
    
    override func resetMoireView(patterns: Array<Pattern>, settings: InitSettings) {
        super.resetMoireView(patterns: patterns, settings: settings)
        self.resetPerformed = true
        self.currentPatterns = patterns
    }
    
    override func highlightPatternView(patternViewIndex: Int) {
        super.highlightPatternView(patternViewIndex: patternViewIndex)
        self.highlightedPatternIndex = patternViewIndex
    }
    
    override func unhighlightPatternView(patternViewIndex: Int) {
        super.unhighlightPatternView(patternViewIndex: patternViewIndex)
        self.unhiddenPatternIndex = patternViewIndex
    }
    
    override func dimPatternView(patternViewIndex: Int) {
        super.dimPatternView(patternViewIndex: patternViewIndex)
        self.dimmedPatternIndex = patternViewIndex
    }
    
    override func undimPatternViews() {
        super.undimPatternViews()
        self.patternsUndimmed = true
    }
    
    override func hidePatternView(patternViewIndex: Int) {
        super.hidePatternView(patternViewIndex: patternViewIndex)
        self.hiddenPatternIndex = patternViewIndex
    }
    
    override func unhidePatternView(patternViewIndex: Int) {
        super.unhidePatternView(patternViewIndex: patternViewIndex)
        self.unhiddenPatternIndex = patternViewIndex
    }
    
    override func modifyPatternView(patternViewIndex: Int, newPattern: Pattern) {
        super.modifyPatternView(patternViewIndex: patternViewIndex, newPattern: newPattern)
        self.currentPatterns?[patternViewIndex] = newPattern
    }
}
