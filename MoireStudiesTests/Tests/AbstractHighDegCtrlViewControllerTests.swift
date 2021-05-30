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
    var mockPatternManagerNormal : MockPatternManagerNormal!
    var mockPatternManagerIllegal : MockPatternManagerIllegal!

    override func setUpWithError() throws {
        self.mockPatternManagerNormal = MockPatternManagerNormal.init()
        self.mockPatternManagerIllegal = MockPatternManagerIllegal.init()
    }
    
    override func tearDownWithError() throws {
        self.mockVC = nil
        self.mockPatternManagerNormal = nil
        self.mockPatternManagerIllegal = nil
    }
    
    public func testModifyPatternSpeed_IndexInRange_NormalPatternManager_CallCorrespondingMethodsWithCorrectParametersAndReturnTrue() {
        let testPatterns = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 0.3456).patterns
        self.mockPatternManagerNormal.setCurrentPatternsControlled(initPatterns: testPatterns)
        self.mockVC = MockHighDegCtrlViewController.init(id: "testId", frame: Constants.UI.highDegreeControlFrames.first!, patterns: testPatterns)
        self.mockVC.patternsDelegate = self.mockPatternManagerNormal
        
        var expectedPatterns = testPatterns
        let newSpeed : CGFloat = 15.4341
        let indexToModify = 1
        assert(expectedPatterns[indexToModify].speed != newSpeed)
        XCTAssertTrue(self.mockVC.modifyPattern(index: indexToModify, speed: newSpeed))
        XCTAssertTrue(self.mockPatternManagerNormal.modifyMulitplePatternsCallers.contains("testId"))
        expectedPatterns[indexToModify].speed = newSpeed
        XCTAssertEqual(self.mockPatternManagerNormal.modifiedPatterns, expectedPatterns)
    }
    
    public func testModifyPatternDirection_IndexInRange_NormalPatternManager_CallCorrespondingMethodsWithCorrectParametersAndReturnTrue() {
        let testPatterns = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 0.3476).patterns
        self.mockPatternManagerNormal.setCurrentPatternsControlled(initPatterns: testPatterns)
        self.mockVC = MockHighDegCtrlViewController.init(id: "testId", frame: Constants.UI.highDegreeControlFrames.first!, patterns: testPatterns)
        self.mockVC.patternsDelegate = self.mockPatternManagerNormal
        
        var expectedPatterns = testPatterns
        let newDirection : CGFloat = 2.12
        let indexToModify = 0
        assert(expectedPatterns[indexToModify].direction != newDirection)
        XCTAssertTrue(self.mockVC.modifyPattern(index: indexToModify, direction: newDirection))
        XCTAssertTrue(self.mockPatternManagerNormal.modifyMulitplePatternsCallers.contains("testId"))
        expectedPatterns[indexToModify].direction = newDirection
        XCTAssertEqual(self.mockPatternManagerNormal.modifiedPatterns, expectedPatterns)
    }
    
    public func testModifyPatternBlackWidth_IndexInRange_NormalPatternManager_CallCorrespondingMethodWithCorrectParametersAndReturnTrue() {
        let testPatterns = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 0.1456).patterns
        self.mockPatternManagerNormal.setCurrentPatternsControlled(initPatterns: testPatterns)
        self.mockVC = MockHighDegCtrlViewController.init(id: "testId", frame: Constants.UI.highDegreeControlFrames.first!, patterns: testPatterns)
        self.mockVC.patternsDelegate = self.mockPatternManagerNormal
        
        var expectedPatterns = testPatterns
        let newBlackWidth : CGFloat = 10.1
        let indexToModify = 0
        assert(expectedPatterns[indexToModify].blackWidth != newBlackWidth)
        XCTAssertTrue(self.mockVC.modifyPattern(index: indexToModify, blackWidth: newBlackWidth))
        XCTAssertTrue(self.mockPatternManagerNormal.modifyMulitplePatternsCallers.contains("testId"))
        expectedPatterns[indexToModify].blackWidth = newBlackWidth
        XCTAssertEqual(self.mockPatternManagerNormal.modifiedPatterns, expectedPatterns)
    }
    
    public func testModifyPatternWhiteWidth_IndexInRange_NormalPatternManager_CallCorrespondingMethodWithCorrectParametersAndReturnTrue() {
        let testPatterns = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 0.145).patterns
        self.mockPatternManagerNormal.setCurrentPatternsControlled(initPatterns: testPatterns)
        self.mockVC = MockHighDegCtrlViewController.init(id: "testId", frame: Constants.UI.highDegreeControlFrames.first!, patterns: testPatterns)
        self.mockVC.patternsDelegate = self.mockPatternManagerNormal
        
        var expectedPatterns = testPatterns
        let newWhiteWidth : CGFloat = 11.1
        let indexToModify = 0
        assert(expectedPatterns[indexToModify].whiteWidth != newWhiteWidth)
        XCTAssertTrue(self.mockVC.modifyPattern(index: indexToModify, whiteWidth: newWhiteWidth))
        XCTAssertTrue(self.mockPatternManagerNormal.modifyMulitplePatternsCallers.contains("testId"))
        expectedPatterns[indexToModify].whiteWidth = newWhiteWidth
        XCTAssertEqual(self.mockPatternManagerNormal.modifiedPatterns, expectedPatterns)
    }
    
    public func testModifyPattern_IllegalPatternManager_CallCorrespondingMethodsReturnFalseAndNoError() {
        let testPatterns = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 0.3456).patterns
        self.mockPatternManagerNormal.setCurrentPatternsControlled(initPatterns: testPatterns)
        self.mockVC = MockHighDegCtrlViewController.init(id: "testId", frame: Constants.UI.highDegreeControlFrames.first!, patterns: testPatterns)
        self.mockVC.patternsDelegate = self.mockPatternManagerIllegal
        
        XCTAssertFalse(self.mockVC.modifyPattern(index: 1, speed: 14.333))
        XCTAssertFalse(self.mockVC.modifyPattern(index: 0, direction: 1.112))
        XCTAssertFalse(self.mockVC.modifyPattern(index: -2, blackWidth: 10.09))
        XCTAssertFalse(self.mockVC.modifyPattern(index: 1, blackWidth: 11.09))
    }
    
    public func testModifyPattern_IndexOutOfRange_NormalPatternManager_CallCorrespondingMethodsReturnFalseAndNoError() {
        let testPatterns = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 0.145).patterns
        self.mockPatternManagerNormal.setCurrentPatternsControlled(initPatterns: testPatterns)
        self.mockVC = MockHighDegCtrlViewController.init(id: "testId", frame: Constants.UI.highDegreeControlFrames.first!, patterns: testPatterns)
        self.mockVC.patternsDelegate = self.mockPatternManagerNormal
        
        XCTAssertFalse(self.mockVC.modifyPattern(index: -1, speed: 14.333))
        XCTAssertFalse(self.mockVC.modifyPattern(index: 199, direction: 1.112))
        XCTAssertFalse(self.mockVC.modifyPattern(index: -2, blackWidth: 10.09))
        XCTAssertFalse(self.mockVC.modifyPattern(index: 3, blackWidth: 11.09))
    }
}
