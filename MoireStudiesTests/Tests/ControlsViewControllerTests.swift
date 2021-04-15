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
    
    private func arrayOfValidSuedoRandomPatterns(numOfPatterns: Int, seed: CGFloat) -> Array<Pattern> {
        let adjustment = seed.truncatingRemainder(dividingBy: 1.0)
        var output: Array<Pattern> = []
        let basePattern = Pattern.init(speed: 10.0, direction: 1.0, blackWidth: 5.0, whiteWidth: 6.0)
        for i in 0..<numOfPatterns {
            let newPattern = Pattern.init(speed: basePattern.speed + CGFloat(i) * 0.01 + adjustment,
                                          direction: basePattern.direction + CGFloat(i) * 0.01 + adjustment,
                                          blackWidth: basePattern.blackWidth + CGFloat(i) * 0.01 + adjustment,
                                          whiteWidth: basePattern.whiteWidth + CGFloat(i) * 0.01 + adjustment)
            assert(BoundsManager.speedRange.contains(newPattern.speed))
            assert(BoundsManager.directionRange.contains(newPattern.direction))
            assert(BoundsManager.blackWidthRange.contains(newPattern.blackWidth))
            assert(BoundsManager.whiteWidthRange.contains(newPattern.whiteWidth))
            output.append(newPattern)
        }
        return output
    }
    
    func testSettingUpAndResettingCtrlViewControllers_validPatternsConfigsIdAndDelegate_NoHighDeg_CreateAndSetUpChildrenCorrectly() {
        let patterns1 = self.arrayOfValidSuedoRandomPatterns(numOfPatterns: 4, seed: 3.123)
        let ids1 = ["a", "b", "c", "d"]
        var config1 = Configurations.init()
        config1.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme3Slider
        config1.highDegreeControlSettings = []
        let delegate = MockPatternManagerLegal()
        self.controlsViewController.setUp(patterns: patterns1, configs: config1, ids: ids1, delegate: delegate)
        
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
        
        let patterns2 = self.arrayOfValidSuedoRandomPatterns(numOfPatterns: 3, seed: 1.404)
        let ids2 = ["c", "d", "e"]
        var config2 = Configurations.init()
        config2.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme2Slider
        config2.highDegreeControlSettings = []
        self.controlsViewController.setUp(patterns: patterns2, configs: config2, ids: ids2, delegate: delegate)
        
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
        let patterns1 = self.arrayOfValidSuedoRandomPatterns(numOfPatterns: 4, seed: 3.173)
        let ids1 = ["a", "b", "c"]
        var config1 = Configurations.init()
        config1.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme3Slider
        config1.highDegreeControlSettings = []
        let delegate = MockPatternManagerLegal()
        self.controlsViewController.setUp(patterns: patterns1, configs: config1, ids: ids1, delegate: delegate)
        
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
        
        let patterns2 = self.arrayOfValidSuedoRandomPatterns(numOfPatterns: 3, seed: 1.474)
        let ids2 = ["c", "d", "e", "f"]
        self.controlsViewController.setUp(patterns: patterns2, configs: config1, ids: ids2, delegate: delegate)
        
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
    
    func testSettingUpAndResettingCtrlViewControllers_validPatternsConfigsId_IllegalDelegate_NoRuntimeError() {
        let patterns1 = self.arrayOfValidSuedoRandomPatterns(numOfPatterns: 4, seed: 3.123)
        let ids1 = ["a", "b", "c", "d"]
        var config1 = Configurations.init()
        config1.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme3Slider
        config1.highDegreeControlSettings = []
        let delegate = MockPatternManagerIllegal()
        self.controlsViewController.setUp(patterns: patterns1, configs: config1, ids: ids1, delegate: delegate)
    }
}
