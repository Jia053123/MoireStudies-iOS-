//
//  HighDegCtrlViewControllerBatchEditing.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-05-31.
//

@testable import MoireStudies
import XCTest
import UIKit

class HighDegCtrlViewControllerBatchEditingTests: XCTestCase {
    var mockPatternManager: MockPatternManagerAlwaysLegal!
    var highDegCtrlViewControllerBatchEditing: HighDegCtrlViewControllerBatchEditing!

    override func setUpWithError() throws {
        self.mockPatternManager = MockPatternManagerAlwaysLegal()
    }

    override func tearDownWithError() throws {
        self.mockPatternManager = nil
        self.highDegCtrlViewControllerBatchEditing = nil
    }
    
    func generateRandomPatternsToSetUpPatternManagerAndViewController(numOfPatterns: Int, seed: CGFloat, id: String) -> Array<Pattern> {
        let originalPatterns = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: numOfPatterns, seed: seed).patterns
        self.mockPatternManager.setCurrentPatternsControlled(initPatterns: originalPatterns)
        self.highDegCtrlViewControllerBatchEditing = HighDegCtrlViewControllerBatchEditing.init(id: id, frame: CGRect.zero, patterns: originalPatterns)
        self.highDegCtrlViewControllerBatchEditing.patternsDelegate = self.mockPatternManager
        
        return originalPatterns
    }
    
    func testModifyRelativeSpeed_ApplyMultiplierCorrectly() {
        let originalPatterns = self.generateRandomPatternsToSetUpPatternManagerAndViewController(numOfPatterns: 3, seed: 8.765, id: "testId")
        
        self.highDegCtrlViewControllerBatchEditing.modifyRelativeSpeed(netMultiplier: 2.1)
        XCTAssert(self.mockPatternManager.modifyMulitplePatternsCallers.contains("testId"))
        let modifiedPatterns = self.mockPatternManager.modifiedPatterns
        XCTAssertNotNil(modifiedPatterns)
        for i in 0..<originalPatterns.count {
            XCTAssertEqual(modifiedPatterns![i].speed, originalPatterns[i].speed * 2.1)
        }
    }
    
    func testModifyRelativeSpeed_SameAccumulativeEndValueRegardlessOfAdjustmentProcess() {
        let originalPatterns = self.generateRandomPatternsToSetUpPatternManagerAndViewController(numOfPatterns: 5, seed: 2.897, id: "testId")
        
        self.highDegCtrlViewControllerBatchEditing.modifyRelativeSpeed(netMultiplier: 0.9)
        self.highDegCtrlViewControllerBatchEditing.modifyRelativeSpeed(netMultiplier: 0.8)
        self.highDegCtrlViewControllerBatchEditing.modifyRelativeSpeed(netMultiplier: -0.6)
        self.highDegCtrlViewControllerBatchEditing.modifyRelativeSpeed(netMultiplier: 0.3)
        self.highDegCtrlViewControllerBatchEditing.modifyRelativeSpeed(netMultiplier: 0.25)
        let modifiedPatterns = self.mockPatternManager.modifiedPatterns
        XCTAssertNotNil(modifiedPatterns)
        for i in 0..<originalPatterns.count {
            XCTAssertEqual(modifiedPatterns![i].speed, originalPatterns[i].speed * 0.25)
        }
    }
    
    func testModifyAllDirection_ResultSmallerThan2Pi_ApplyAdjustmentCorrectly() {
        let originalPatterns = self.generateRandomPatternsToSetUpPatternManagerAndViewController(numOfPatterns: 4, seed: 8.095, id: "testId")
        
        self.highDegCtrlViewControllerBatchEditing.modifyAllDirection(netAdjustment: 0.01)
        XCTAssert(self.mockPatternManager.modifyMulitplePatternsCallers.contains("testId"))
        let modifiedPatterns = self.mockPatternManager.modifiedPatterns
        XCTAssertNotNil(modifiedPatterns)
        for i in 0..<originalPatterns.count {
            assert(originalPatterns[i].direction < (BoundsManager.directionRange.upperBound - 0.01))
            XCTAssertEqual(modifiedPatterns![i].direction, originalPatterns[i].direction + 0.01)
        }
    }
    
    func testModifyAllDirection_ResultLargerThanUpperBound_ApplyAdjustmentCorrectly() {
        let originalPatterns = self.generateRandomPatternsToSetUpPatternManagerAndViewController(numOfPatterns: 4, seed: 8.095, id: "testId")
        
        self.highDegCtrlViewControllerBatchEditing.modifyAllDirection(netAdjustment: 6*CGFloat.pi + 0.02)
        let modifiedPatterns = self.mockPatternManager.modifiedPatterns
        XCTAssertNotNil(modifiedPatterns)
        for i in 0..<originalPatterns.count {
            assert(originalPatterns[i].direction < (BoundsManager.directionRange.upperBound - 0.02))
            XCTAssert(abs(modifiedPatterns![i].direction - (originalPatterns[i].direction + 0.02)) < 0.00001)
        }
    }
    
    func testModifyAllDirection_ResultSmallerThanLowerBound_ApplyAdjustmentCorrectly() {
        let originalPatterns = self.generateRandomPatternsToSetUpPatternManagerAndViewController(numOfPatterns: 4, seed: 8.995, id: "testId")
        
        self.highDegCtrlViewControllerBatchEditing.modifyAllDirection(netAdjustment: -1 * (8*CGFloat.pi + 0.02))
        let modifiedPatterns = self.mockPatternManager.modifiedPatterns
        XCTAssertNotNil(modifiedPatterns)
        for i in 0..<originalPatterns.count {
            assert(originalPatterns[i].direction > (BoundsManager.directionRange.lowerBound + 0.02))
            XCTAssert(abs(modifiedPatterns![i].direction - (originalPatterns[i].direction - 0.02)) < 0.00001)
        }
    }
    
    func testModifyAllDirection_SameAccumulativeEndValueRegardlessOfAdjustmentProcess() {
        let originalPatterns = self.generateRandomPatternsToSetUpPatternManagerAndViewController(numOfPatterns: 4, seed: 8.655, id: "testId")
        
        self.highDegCtrlViewControllerBatchEditing.modifyAllDirection(netAdjustment: 0.01)
        self.highDegCtrlViewControllerBatchEditing.modifyAllDirection(netAdjustment: 0.02)
        self.highDegCtrlViewControllerBatchEditing.modifyAllDirection(netAdjustment: -0.02)
        self.highDegCtrlViewControllerBatchEditing.modifyAllDirection(netAdjustment: 0.05)
        
        let modifiedPatterns = self.mockPatternManager.modifiedPatterns
        XCTAssertNotNil(modifiedPatterns)
        for i in 0..<originalPatterns.count {
            assert(originalPatterns[i].direction < (BoundsManager.directionRange.upperBound - 0.05))
            XCTAssertEqual(modifiedPatterns![i].direction, originalPatterns[i].direction + 0.05)
        }
    }
    
    func testModifyAllFillRatio_ApplyMultiplierCorrectly() {
        let originalPatterns = self.generateRandomPatternsToSetUpPatternManagerAndViewController(numOfPatterns: 3, seed: 2.195, id: "testId")
        
        self.highDegCtrlViewControllerBatchEditing.modifyAllFillRatio(netMultiplier: 1.1)
        XCTAssert(self.mockPatternManager.modifyMulitplePatternsCallers.contains("testId"))
        let modifiedPatterns = self.mockPatternManager.modifiedPatterns
        XCTAssertNotNil(modifiedPatterns)
        for i in 0..<originalPatterns.count {
            let originalFillRatio = Utilities.convertToFillRatioAndScaleFactor(blackWidth: originalPatterns[i].blackWidth,
                                                                               whiteWidth: originalPatterns[i].whiteWidth).fillRatio
            let modifiedFillRatio = Utilities.convertToFillRatioAndScaleFactor(blackWidth: modifiedPatterns![i].blackWidth,
                                                                               whiteWidth: modifiedPatterns![i].whiteWidth).fillRatio
            XCTAssertEqual(modifiedFillRatio, originalFillRatio * 1.1)
        }
    }
    
    func testModifyAllFillRatio_SameAccumulativeEndValueRegardlessOfAdjustmentProcess() {
        let originalPatterns = self.generateRandomPatternsToSetUpPatternManagerAndViewController(numOfPatterns: 3, seed: 2.190, id: "testId")
            
        self.highDegCtrlViewControllerBatchEditing.modifyAllFillRatio(netMultiplier: 1.1)
        self.highDegCtrlViewControllerBatchEditing.modifyAllFillRatio(netMultiplier: 1.4)
        self.highDegCtrlViewControllerBatchEditing.modifyAllFillRatio(netMultiplier: -1.45)
        self.highDegCtrlViewControllerBatchEditing.modifyAllFillRatio(netMultiplier: 1.5)
        
        let modifiedPatterns = self.mockPatternManager.modifiedPatterns
        XCTAssertNotNil(modifiedPatterns)
        for i in 0..<originalPatterns.count {
            let originalFillRatio = Utilities.convertToFillRatioAndScaleFactor(blackWidth: originalPatterns[i].blackWidth,
                                                                               whiteWidth: originalPatterns[i].whiteWidth).fillRatio
            let modifiedFillRatio = Utilities.convertToFillRatioAndScaleFactor(blackWidth: modifiedPatterns![i].blackWidth,
                                                                               whiteWidth: modifiedPatterns![i].whiteWidth).fillRatio
            XCTAssertEqual(modifiedFillRatio, originalFillRatio * 1.5)
        }
    }
    
    func testModifyAllScale_ApplyAdjustmentCorrectly() {
        let originalPatterns = self.generateRandomPatternsToSetUpPatternManagerAndViewController(numOfPatterns: 3, seed: 2.198, id: "testId")
        
        self.highDegCtrlViewControllerBatchEditing.modifyAllScale(netAdjustment: 0.87)
        XCTAssert(self.mockPatternManager.modifyMulitplePatternsCallers.contains("testId"))
        let modifiedPatterns = self.mockPatternManager.modifiedPatterns
        XCTAssertNotNil(modifiedPatterns)
        for i in 0..<originalPatterns.count {
            let originalScaleFactor = Utilities.convertToFillRatioAndScaleFactor(blackWidth: originalPatterns[i].blackWidth,
                                                                               whiteWidth: originalPatterns[i].whiteWidth).scaleFactor
            let modifiedScaleFactor = Utilities.convertToFillRatioAndScaleFactor(blackWidth: modifiedPatterns![i].blackWidth,
                                                                               whiteWidth: modifiedPatterns![i].whiteWidth).scaleFactor
            XCTAssertEqual(modifiedScaleFactor, originalScaleFactor + 0.87)
        }
    }
    
    func testModifyAllScale_SameAccumulativeEndValueRegardlessOfAdjustmentProcess() {
        let originalPatterns = self.generateRandomPatternsToSetUpPatternManagerAndViewController(numOfPatterns: 3, seed: 2.108, id: "testId")
        
        self.highDegCtrlViewControllerBatchEditing.modifyAllScale(netAdjustment: 0.2)
        self.highDegCtrlViewControllerBatchEditing.modifyAllScale(netAdjustment: 0.4)
        self.highDegCtrlViewControllerBatchEditing.modifyAllScale(netAdjustment: -0.8)
        self.highDegCtrlViewControllerBatchEditing.modifyAllScale(netAdjustment: 0.75)
        
        let modifiedPatterns = self.mockPatternManager.modifiedPatterns
        XCTAssertNotNil(modifiedPatterns)
        for i in 0..<originalPatterns.count {
            let originalScaleFactor = Utilities.convertToFillRatioAndScaleFactor(blackWidth: originalPatterns[i].blackWidth,
                                                                               whiteWidth: originalPatterns[i].whiteWidth).scaleFactor
            let modifiedScaleFactor = Utilities.convertToFillRatioAndScaleFactor(blackWidth: modifiedPatterns![i].blackWidth,
                                                                               whiteWidth: modifiedPatterns![i].whiteWidth).scaleFactor
            XCTAssertEqual(modifiedScaleFactor, originalScaleFactor + 0.75)
        }
    }
}
