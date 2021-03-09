//
//  MokeControlsViewController.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-09.
//

@testable import MoireStudies
import Foundation
import UIKit

class MockControlsViewController: ControlsViewController {
    private(set) var currentPatterns: Array<Pattern>?
    private(set) var setUpPerformed: Bool = false
    private(set) var resetPerformed: Bool = false
    
    func resetTestingRecords() {
        self.currentPatterns = nil
        self.setUpPerformed = false
        self.resetPerformed = false
    }
    
    override func setup(patterns: Array<Pattern>, settings: InitSettings, matcher: CtrlAndPatternMatcher, delegate: PatternManager) {
        super.setup(patterns: patterns, settings: settings, matcher: matcher, delegate: delegate)
        self.setUpPerformed = true
        self.currentPatterns = patterns
    }
    
    override func reset(patterns: Array<Pattern>, settings: InitSettings, matcher: CtrlAndPatternMatcher, delegate: PatternManager) {
        super.reset(patterns: patterns, settings: settings, matcher: matcher, delegate: delegate)
        self.resetPerformed = true
        self.currentPatterns = patterns
    }
}
