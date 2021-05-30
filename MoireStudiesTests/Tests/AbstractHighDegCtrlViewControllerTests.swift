//
//  AbstractHighDegCtrlViewControllerTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-05-28.
//

import XCTest
@testable import MoireStudies

class AbstractHighDegCtrlViewControllerTests: XCTestCase {
    var mockVC : MockHighDegCtrlViewController!
    var mockPatternManagerLegal : MockPatternManagerLegal!
    var mockPatternManagerIllegal : MockPatternManagerIllegal!

    override func setUpWithError() throws {
        self.mockPatternManagerLegal = MockPatternManagerLegal.init()
        self.mockPatternManagerIllegal = MockPatternManagerIllegal.init()
    }
    
    override func tearDownWithError() throws {
        self.mockVC = nil
        self.mockPatternManagerLegal = nil
        self.mockPatternManagerIllegal = nil
    }
    
    public func testModifyPatternSpeed_NormalPatternManager_CallCorrespondingMethod() {
        let testPatterns = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 0.3456).patterns
        self.mockPatternManagerLegal.setCurrentPatternsControlled(initPatterns: testPatterns)
        self.mockVC = MockHighDegCtrlViewController.init(id: "testId", frame: Constants.UI.highDegreeControlFrames.first!, patterns: testPatterns)
        self.mockVC.patternsDelegate = self.mockPatternManagerLegal
        
        var expectedPatterns = testPatterns
        let newSpeed1 : CGFloat = 15.4341
        let indexToModify1 = 1
        assert(expectedPatterns[indexToModify1].speed != newSpeed1)
        XCTAssertTrue(self.mockVC.modifyPattern(index: indexToModify1, speed: newSpeed1))
        XCTAssertTrue(self.mockPatternManagerLegal.modifyMulitplePatternsCallers.contains("testId"))
        expectedPatterns[indexToModify1].speed = newSpeed1
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPatterns, expectedPatterns)
        
        
    }
}
