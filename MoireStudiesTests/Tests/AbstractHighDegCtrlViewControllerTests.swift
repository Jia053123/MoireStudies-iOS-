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
        let newSpeed : CGFloat = 15.4341
        let indexToModify = 1
        assert(expectedPatterns[indexToModify].speed != newSpeed)
        XCTAssertTrue(self.mockVC.modifyPattern(index: indexToModify, speed: newSpeed))
        XCTAssertTrue(self.mockPatternManagerLegal.modifyMulitplePatternsCallers.contains("testId"))
        expectedPatterns[indexToModify].speed = newSpeed
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPatterns, expectedPatterns)
    }
    
    public func testModifyPatternDirection_NormalPatternManager_CallCorrespondingMethod() {
        let testPatterns = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 0.3476).patterns
        self.mockPatternManagerLegal.setCurrentPatternsControlled(initPatterns: testPatterns)
        self.mockVC = MockHighDegCtrlViewController.init(id: "testId", frame: Constants.UI.highDegreeControlFrames.first!, patterns: testPatterns)
        self.mockVC.patternsDelegate = self.mockPatternManagerLegal
        
        var expectedPatterns = testPatterns
        let newDirection : CGFloat = 2.12
        let indexToModify = 0
        assert(expectedPatterns[indexToModify].direction != newDirection)
        XCTAssertTrue(self.mockVC.modifyPattern(index: indexToModify, direction: newDirection))
        XCTAssertTrue(self.mockPatternManagerLegal.modifyMulitplePatternsCallers.contains("testId"))
        expectedPatterns[indexToModify].direction = newDirection
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPatterns, expectedPatterns)
    }
    
    public func testModifyPatternBlackWidth_NormalPatternManager_CallCorrespondingMethod() {
        let testPatterns = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 0.1456).patterns
        self.mockPatternManagerLegal.setCurrentPatternsControlled(initPatterns: testPatterns)
        self.mockVC = MockHighDegCtrlViewController.init(id: "testId", frame: Constants.UI.highDegreeControlFrames.first!, patterns: testPatterns)
        self.mockVC.patternsDelegate = self.mockPatternManagerLegal
        
        var expectedPatterns = testPatterns
        let newBlackWidth : CGFloat = 2.12
        let indexToModify = 0
        assert(expectedPatterns[indexToModify].blackWidth != newBlackWidth)
        XCTAssertTrue(self.mockVC.modifyPattern(index: indexToModify, blackWidth: newBlackWidth))
        XCTAssertTrue(self.mockPatternManagerLegal.modifyMulitplePatternsCallers.contains("testId"))
        expectedPatterns[indexToModify].blackWidth = newBlackWidth
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPatterns, expectedPatterns)
    }
    
    public func testModifyPatternWhiteWidth_NormalPatternManager_CallCorrespondingMethod() {
        let testPatterns = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 0.1456).patterns
        self.mockPatternManagerLegal.setCurrentPatternsControlled(initPatterns: testPatterns)
        self.mockVC = MockHighDegCtrlViewController.init(id: "testId", frame: Constants.UI.highDegreeControlFrames.first!, patterns: testPatterns)
        self.mockVC.patternsDelegate = self.mockPatternManagerLegal
        
        var expectedPatterns = testPatterns
        let newWhiteWidth : CGFloat = 2.12
        let indexToModify = 0
        assert(expectedPatterns[indexToModify].whiteWidth != newWhiteWidth)
        XCTAssertTrue(self.mockVC.modifyPattern(index: indexToModify, whiteWidth: newWhiteWidth))
        XCTAssertTrue(self.mockPatternManagerLegal.modifyMulitplePatternsCallers.contains("testId"))
        expectedPatterns[indexToModify].whiteWidth = newWhiteWidth
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPatterns, expectedPatterns)
    }
}
