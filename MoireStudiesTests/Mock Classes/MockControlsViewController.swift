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
    private(set) var timesUpdatePatternsCalled: Int = 0
    private(set) var enteredSelectionMode: Bool = false
    private(set) var exitedSelectionMode: Bool = false
    private(set) var ids: Array<String>?
    private(set) var highDegIds: Array<String>?
    private(set) var configs: Configurations?
    override var selectedPatternIndexes: Array<Int> {return []}
    
    func resetTestingRecords() {
        self.initPatterns = nil
        self.setUpPerformed = false
        self.resetPerformed = false
        self.timesUpdatePatternsCalled = 0
        self.enteredSelectionMode = false
        self.exitedSelectionMode = false
        self.ids = nil
        self.highDegIds = nil
    }
    
    override func setUp(patterns: Array<Pattern>, configs: Configurations, ids: Array<String>, highDegIds: Array<String>, delegate: PatternManager) {
        self.setUpPerformed = true
        self.initPatterns = patterns
        self.ids = ids
        self.highDegIds = highDegIds
        self.configs = configs
    }
    
    override func reset(patterns: Array<Pattern>, configs: Configurations, ids: Array<String>, highDegIds: Array<String>, delegate: PatternManager) {
        self.resetPerformed = true
        self.initPatterns = patterns
        self.ids = ids
        self.highDegIds = highDegIds
        self.configs = configs
    }
    
    override func updatePatterns(newPatterns: Array<Pattern>, exceptForIDs: Array<String>?) {
        self.timesUpdatePatternsCalled += 1
    }
    
    override func enterSelectionMode() {
        self.enteredSelectionMode = true
    }
    
    override func exitSelectionMode() {
        self.exitedSelectionMode = true 
    }
}
