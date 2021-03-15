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
    private(set) var ids: Array<Int>?
    
    func resetTestingRecords() {
        self.initPatterns = nil
        self.setUpPerformed = false
        self.resetPerformed = false
        self.ids = nil
    }
    
    override func setUp(patterns: Array<Pattern>, settings: InitSettings, ids: Array<Int>, delegate: PatternManager) {
        self.setUpPerformed = true
        self.initPatterns = patterns
        self.ids = ids
    }
    
    override func reset(patterns: Array<Pattern>, settings: InitSettings, ids: Array<Int>, delegate: PatternManager) {
        self.resetPerformed = true
        self.initPatterns = patterns
        self.ids = ids
    }
}
