//
//  ControlsViewControllerTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-04-12.
//

@testable import MoireStudies
import XCTest
import UIKit

class ControlsViewControllerTests: XCTestCase {
    var controlsViewController: ControlsViewController!

    override func setUpWithError() throws {
        self.controlsViewController = ControlsViewController.init()
    }

    override func tearDownWithError() throws {
        self.controlsViewController = nil
    }
    
    func testSettingUpAndResettingCtrlViewControllers_validPatternsConfigsIdAndDelegate_NoHighDeg_CreateAndSetUpChildrenCorrectly() {
        let patterns1 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 4, seed: 3.123).patterns
        let ids1 = ["a", "b", "c", "d"]
        var config1 = Configurations.init()
        config1.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme3Slider
        config1.highDegreeControlSettings = []
        let delegate = MockPatternManagerAlwaysLegal()
        self.controlsViewController.setUp(patterns: patterns1, configs: config1, ids: ids1, highDegIds: [], delegate: delegate)
        
        if self.controlsViewController.children.count != 4 {
            XCTFail()
        } else {
            for i in 0 ..< self.controlsViewController.children.count {
                let c = self.controlsViewController.children[i]
                XCTAssertNotNil(c as? CtrlViewControllerSch3)
                let cvc = c as? CtrlViewControllerSch3
                XCTAssertEqual(cvc?.id, ids1[i])
                XCTAssertEqual(cvc?.view.frame, config1.controlFrames[i])
                XCTAssertEqual(cvc?.initPattern, patterns1[i])
            }
        }
        
        let patterns2 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 1.404).patterns
        let ids2 = ["c", "d", "e"]
        var config2 = Configurations.init()
        config2.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme2Slider
        config2.highDegreeControlSettings = []
        self.controlsViewController.setUp(patterns: patterns2, configs: config2, ids: ids2, highDegIds: [], delegate: delegate)
        
        if self.controlsViewController.children.count != 3 {
            XCTFail()
        } else {
            for i in 0 ..< self.controlsViewController.children.count {
                let c = self.controlsViewController.children[i]
                XCTAssertNotNil(c as? CtrlViewControllerSch2)
                let cvc = c as? CtrlViewControllerSch2
                XCTAssertEqual(cvc?.id, ids2[i])
                XCTAssertEqual(cvc?.view.frame, config2.controlFrames[i])
                XCTAssertEqual(cvc?.initPattern, patterns2[i])
            }
        }
    }
    
    func testSettingUpAndResettingCtrlViewControllers_MismatchedPatternsAndIdNum_NoHighDeg_CreateAControllerForEachId() {
        let patterns1 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 4, seed: 3.173).patterns
        let ids1 = ["a", "b", "c"]
        var config1 = Configurations.init()
        config1.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme3Slider
        config1.highDegreeControlSettings = []
        let delegate = MockPatternManagerAlwaysLegal()
        self.controlsViewController.setUp(patterns: patterns1, configs: config1, ids: ids1, highDegIds: [], delegate: delegate)
        
        if self.controlsViewController.children.count != 3 {
            XCTFail()
        } else {
            for i in 0 ..< self.controlsViewController.children.count {
                let c = self.controlsViewController.children[i]
                XCTAssertNotNil(c as? CtrlViewControllerSch3)
                let cvc = c as? CtrlViewControllerSch3
                XCTAssertEqual(cvc?.id, ids1[i])
                XCTAssertEqual(cvc?.view.frame, config1.controlFrames[i])
                XCTAssertEqual(cvc?.initPattern, patterns1[i])
            }
        }
        
        let patterns2 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 1.474).patterns
        let ids2 = ["c", "d", "e", "f"]
        self.controlsViewController.setUp(patterns: patterns2, configs: config1, ids: ids2, highDegIds: [], delegate: delegate)
        
        if self.controlsViewController.children.count != 4 {
            XCTFail()
        } else {
            for i in 0 ..< self.controlsViewController.children.count {
                let c = self.controlsViewController.children[i]
                XCTAssertNotNil(c as? CtrlViewControllerSch3)
                let cvc = c as? CtrlViewControllerSch3
                XCTAssertEqual(cvc?.id, ids2[i])
                XCTAssertEqual(cvc?.view.frame, config1.controlFrames[i])
                if i < 3 {
                    XCTAssertEqual(cvc?.initPattern, patterns2[i])
                } else {
                    XCTAssertNil(cvc?.initPattern)
                }
            }
        }
    }
    
    func testSettingUpAndResettingCtrlViewControllers_validAndMisMatchedPatternsConfigsIdAndDelegate_WithHighDeg_CreateAndSetUpAChildForEachId() {
        let patterns1 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 4, seed: 3.123).patterns
        let ids1 = ["a", "b", "c", "d"]
        let hdIds1 = ["abd"]
        var config1 = Configurations.init()
        config1.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme3Slider
        let hdcs1 = HighDegreeControlSettings.init(highDegCtrlSchemeSetting: .basicScheme, indexesOfPatternControlled: [0,1,3])
        config1.highDegreeControlSettings = [hdcs1]
        let delegate = MockPatternManagerAlwaysLegal()
        self.controlsViewController.setUp(patterns: patterns1, configs: config1, ids: ids1, highDegIds: hdIds1, delegate: delegate)
        
        if self.controlsViewController.children.count != 5 {
            XCTFail()
        } else {
            for i in 0 ..< self.controlsViewController.children.count - 1 {
                let c = self.controlsViewController.children[i]
                XCTAssertNotNil(c as? CtrlViewControllerSch3)
                let cvc = c as? CtrlViewControllerSch3
                XCTAssertEqual(cvc?.id, ids1[i])
                XCTAssertEqual(cvc?.view.frame, config1.controlFrames[i])
                XCTAssertEqual(cvc?.initPattern, patterns1[i])
            }
            let i = self.controlsViewController.children.count - 1
            let c = self.controlsViewController.children[i]
            XCTAssertNotNil(c as? HighDegCtrlViewControllerBatchEditing)
            let cvc = c as? HighDegCtrlViewControllerBatchEditing
            XCTAssertEqual(cvc?.id, hdIds1.first!)
            XCTAssertEqual(cvc?.view.frame, config1.highDegControlFrames.first)
            XCTAssertEqual(cvc?.initPattern[0], patterns1[0])
            XCTAssertEqual(cvc?.initPattern[1], patterns1[1])
            XCTAssertEqual(cvc?.initPattern[2], patterns1[3])
        }
        
        let patterns2 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: -1.404).patterns
        let ids2 = ["c", "d", "e"]
        let hdIds2 = ["ce", "de", "cde"]
        var config2 = Configurations.init()
        let hdcs21 = HighDegreeControlSettings.init(highDegCtrlSchemeSetting: .basicScheme, indexesOfPatternControlled: [0,2])
        let hdcs22 = HighDegreeControlSettings.init(highDegCtrlSchemeSetting: .basicScheme, indexesOfPatternControlled: [1,2])
        let hdcs23 = HighDegreeControlSettings.init(highDegCtrlSchemeSetting: .basicScheme, indexesOfPatternControlled: [0,1,2])
        let hdcs24 = HighDegreeControlSettings.init(highDegCtrlSchemeSetting: .basicScheme, indexesOfPatternControlled: [0,1])
        config2.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme2Slider
        config2.highDegreeControlSettings = [hdcs21, hdcs22, hdcs23, hdcs24] // last setting to be ignored
        self.controlsViewController.setUp(patterns: patterns2, configs: config2, ids: ids2, highDegIds: hdIds2, delegate: delegate)

        if self.controlsViewController.children.count != 6 {
            XCTFail()
        } else {
            for i in 0 ..< 3 {
                let c = self.controlsViewController.children[i]
                XCTAssertNotNil(c as? CtrlViewControllerSch2)
                let cvc = c as? CtrlViewControllerSch2
                XCTAssertEqual(cvc?.id, ids2[i])
                XCTAssertEqual(cvc?.view.frame, config2.controlFrames[i])
                XCTAssertEqual(cvc?.initPattern, patterns2[i])
            }
            for i in 3 ..< 6 {
                let c = self.controlsViewController.children[i]
                XCTAssertNotNil(c as? HighDegCtrlViewControllerBatchEditing)
                let cvc = c as? HighDegCtrlViewControllerBatchEditing
                XCTAssertEqual(cvc?.id, hdIds2[i-3])
                XCTAssertEqual(cvc?.view.frame, config1.highDegControlFrames[i-3])
                XCTAssertEqual(cvc?.initPattern, config2.highDegreeControlSettings[i-3].indexesOfPatternControlled.map({patterns2[$0]}))
            }
        }
    }
    
    func testSettingUpAndResettingCtrlViewControllers_validPatternsConfigsId_IllegalDelegate_NoRuntimeError() {
        let patterns1 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 4, seed: 3.123).patterns
        let ids1 = ["a", "b", "c", "d"]
        var config1 = Configurations.init()
        config1.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme3Slider
        config1.highDegreeControlSettings = []
        let delegate = MockPatternManagerAlwaysIllegal()
        self.controlsViewController.setUp(patterns: patterns1, configs: config1, ids: ids1, highDegIds: [], delegate: delegate)
    }
    
    func testEnteringAndExitingSelectionMode_TheFirstDegreeControllersEnterAndExitSelectionMode() {
        let patterns1 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 4, seed: 1.998).patterns
        let ids1 = ["a", "b", "c", "d"]
        let hdIds1 = ["abd"]
        var config1 = Configurations.init()
        config1.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme3Slider
        let hdcs1 = HighDegreeControlSettings.init(highDegCtrlSchemeSetting: .basicScheme, indexesOfPatternControlled: [0,1,3])
        config1.highDegreeControlSettings = [hdcs1]
        let delegate = MockPatternManagerAlwaysLegal()
        self.controlsViewController.setUp(patterns: patterns1, configs: config1, ids: ids1, highDegIds: hdIds1, delegate: delegate)
        
        self.controlsViewController.enterSelectionMode()
        for i in 0..<4 {
            let c = self.controlsViewController.children[i]
            guard let cvc = c as? CtrlViewController else {
                assertionFailure()
                return
            }
            XCTAssertTrue(cvc.isInSelectionMode)
        }
        
        self.controlsViewController.exitSelectionMode()
        for i in 0..<4 {
            let c = self.controlsViewController.children[i]
            guard let cvc = c as? CtrlViewController else {
                assertionFailure()
                return
            }
            XCTAssertFalse(cvc.isInSelectionMode)
        }
        
        self.controlsViewController.exitSelectionMode()
        self.controlsViewController.exitSelectionMode()
        self.controlsViewController.enterSelectionMode()
        self.controlsViewController.enterSelectionMode()
        for i in 0..<4 {
            let c = self.controlsViewController.children[i]
            guard let cvc = c as? CtrlViewController else {
                assertionFailure()
                return
            }
            XCTAssertTrue(cvc.isInSelectionMode)
        }
    }
    
    func testGettingSelectedPatternIndexes_InSelectionMode_ReturnTheIndexesOfThePatternsSelectedInAscendingOrder() {
        let patterns1 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 4, seed: 3.113).patterns
        let ids1 = ["a", "b", "c", "d"]
        var config1 = Configurations.init()
        config1.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme3Slider
        config1.highDegreeControlSettings = []
        let delegate = MockPatternManagerAlwaysLegal()
        self.controlsViewController.setUp(patterns: patterns1, configs: config1, ids: ids1, highDegIds: [], delegate: delegate)
        
        self.controlsViewController.enterSelectionMode()
        (self.controlsViewController.children[3] as! CtrlViewControllerSch3).selectIfInSelectionMode()
        (self.controlsViewController.children[1] as! CtrlViewControllerSch3).selectIfInSelectionMode()
        XCTAssertEqual(self.controlsViewController.selectedPatternIndexes, [1,3])
    }
    
    func testGettingSelectedPatternIndexes_NotInSelectionMode_ReturnEmptyArray() {
        let patterns1 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 4, seed: 3.113).patterns
        let ids1 = ["a", "b", "c", "d", "e"]
        var config1 = Configurations.init()
        config1.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme3Slider
        config1.highDegreeControlSettings = []
        let delegate = MockPatternManagerAlwaysLegal()
        self.controlsViewController.setUp(patterns: patterns1, configs: config1, ids: ids1, highDegIds: [], delegate: delegate)
        
        XCTAssertEqual(self.controlsViewController.selectedPatternIndexes, [])
        self.controlsViewController.enterSelectionMode()
        (self.controlsViewController.children[2] as! CtrlViewControllerSch3).selectIfInSelectionMode()
        (self.controlsViewController.children[0] as! CtrlViewControllerSch3).selectIfInSelectionMode()
        self.controlsViewController.exitSelectionMode()
        XCTAssertEqual(self.controlsViewController.selectedPatternIndexes, [])
    }
}
