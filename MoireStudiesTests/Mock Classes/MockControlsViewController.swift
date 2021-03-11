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
    private(set) var initPatterns: Array<Pattern>?
    private(set) var setUpPerformed: Bool = false
    private(set) var resetPerformed: Bool = false
    private(set) var controlAndPatternMatcher: CtrlAndPatternMatcher?
    
    func resetTestingRecords() {
        self.initPatterns = nil
        self.setUpPerformed = false
        self.resetPerformed = false
        self.controlAndPatternMatcher = nil
    }
    
    override func setUp(patterns: Array<Pattern>, settings: InitSettings, matcher: CtrlAndPatternMatcher, delegate: PatternManager) {
        super.setUp(patterns: patterns, settings: settings, matcher: matcher, delegate: delegate)
        self.setUpPerformed = true
        self.initPatterns = patterns
        self.controlAndPatternMatcher = matcher
    }
    
    override func reset(patterns: Array<Pattern>, settings: InitSettings, matcher: CtrlAndPatternMatcher, delegate: PatternManager) {
        super.reset(patterns: patterns, settings: settings, matcher: matcher, delegate: delegate)
        self.resetPerformed = true
        self.initPatterns = patterns
        
    }
}
