//
//  BasicCtrlViewControllerTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-05.
//

@testable import MoireStudies
import XCTest
import UIKit


// TODO: test the match method! 
class CtrlViewControllerSch3TestsLegal: XCTestCase {
    let id = "1111"
    var ctrlViewController: CtrlViewControllerSch3!
    var mockPatternManagerLegal: MockPatternManagerAlwaysLegal!
    let testPattern1 = Pattern.init(speed: 25.0, direction: 1.78, blackWidth: 5.34, whiteWidth: 7.22)
    
    override func setUpWithError() throws {
        assert(Utilities.isWithinBounds(pattern: testPattern1))
        self.ctrlViewController = CtrlViewControllerSch3.init(id: self.id, frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), pattern: self.testPattern1)
        self.mockPatternManagerLegal = MockPatternManagerAlwaysLegal()
        self.mockPatternManagerLegal!.setCurrentPatternControlled(initPattern: self.testPattern1)
        self.ctrlViewController?.patternDelegate = self.mockPatternManagerLegal
    }

    override func tearDownWithError() throws {
        self.ctrlViewController = nil
        self.mockPatternManagerLegal = nil
    }
    
    func testModifyPattern_EndWithBlackAndWhiteWidth_CorrectMethodsCalledWithCorrectParametersAndPatternModifiedCorrectly() {
        let speedToSet: CGFloat = 25.465
        let directionToSet: CGFloat = 1.655
        let blackWidthToSet: CGFloat = 4.312
        let whiteWidthToSet: CGFloat = 6.998
        
        let speedToExpect = speedToSet
        let directionToExpect = directionToSet
        let blackWidthToExpect = blackWidthToSet
        let whiteWidthToExpect = whiteWidthToSet
        
        assert(self.ctrlViewController.modifyPattern(speed: 22))
        assert(self.ctrlViewController.modifyPattern(blackWidth: 6.45))
        assert(self.ctrlViewController.modifyPattern(speed: speedToSet))
        assert(self.ctrlViewController.modifyPattern(whiteWidth: 7.346))
        assert(self.ctrlViewController.modifyPattern(direction: 0.765))
        assert(self.ctrlViewController.modifyPattern(fillRatio: 0.845))
        assert(self.ctrlViewController.modifyPattern(scaleFactor: 1.65))
        assert(self.ctrlViewController.modifyPattern(whiteWidth: whiteWidthToSet))
        assert(self.ctrlViewController.modifyPattern(blackWidth: blackWidthToSet))
        assert(self.ctrlViewController.modifyPattern(direction: directionToSet))
        
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPattern?.speed, speedToExpect)
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPattern?.direction, directionToExpect)
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPattern?.blackWidth, blackWidthToExpect)
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPattern?.whiteWidth, whiteWidthToExpect)
        XCTAssertEqual(self.mockPatternManagerLegal.modifySpeedCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.modifySpeedCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerLegal.modifyDirectionCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.modifyDirectionCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerLegal.modifyBlackWidthCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.modifyBlackWidthCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerLegal.modifyWhiteWidthCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.modifyWhiteWidthCallers.first, self.id)
    }
    
    func testModifyPattern_EndWithScaleAndFill_CorrectMethodsCalledWithCorrectParametersAndPatternModifiedCorrectly() {
        let speedToSet: CGFloat = 24.071
        let directionToSet: CGFloat = 1.398
        let scaleFactorToSet: CGFloat = 3.456
        let fillRatioToSet: CGFloat = 0.455
        
        let speedToExpect = speedToSet
        let directionToExpect = directionToSet
        let result = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: fillRatioToSet, scaleFactor: scaleFactorToSet)
        let blackWidthToExpect = result.blackWidth
        let whiteWidthToExpect = result.whiteWidth
        
        assert(self.ctrlViewController.modifyPattern(speed: 21.543))
        assert(self.ctrlViewController.modifyPattern(fillRatio: 0.88))
        assert(self.ctrlViewController.modifyPattern(blackWidth: 7.937))
        assert(self.ctrlViewController.modifyPattern(whiteWidth: 7.045))
        assert(self.ctrlViewController.modifyPattern(scaleFactor: 3.232))
        assert(self.ctrlViewController.modifyPattern(scaleFactor: scaleFactorToSet))
        assert(self.ctrlViewController.modifyPattern(fillRatio: fillRatioToSet))
        assert(self.ctrlViewController.modifyPattern(speed: speedToSet))
        assert(self.ctrlViewController.modifyPattern(direction: 0.998))
        assert(self.ctrlViewController.modifyPattern(direction: directionToSet))
        
        XCTAssertEqual(self.mockPatternManagerLegal.modifySpeedCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.modifySpeedCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerLegal.modifyDirectionCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.modifyDirectionCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerLegal.modifyBlackWidthCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.modifyBlackWidthCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerLegal.modifyWhiteWidthCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.modifyWhiteWidthCallers.first, self.id)
        
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPattern?.speed, speedToExpect)
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPattern?.direction, directionToExpect)
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPattern?.blackWidth, blackWidthToExpect)
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPattern?.whiteWidth, whiteWidthToExpect)
    }
    
    func testChangeDisplayProperties_CorrectMethodsCalledWithCorrectParameters() {
        self.ctrlViewController.highlightPattern()
        self.ctrlViewController.dimPattern()
        assert(self.ctrlViewController.hidePattern())
        self.ctrlViewController.unhidePattern()
        self.ctrlViewController.unhighlightPattern()
        self.ctrlViewController.undimPattern()
        
        XCTAssertEqual(self.mockPatternManagerLegal.highlightCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.highlightCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerLegal.unhighlightCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.unhighlightCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerLegal.dimCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.dimCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerLegal.undimCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.undimCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerLegal.hideCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.hideCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerLegal.unhideCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.unhideCallers.first, self.id)
    }
    
    func testDuplicatePattern_CorrectMethodsCalledWithCorrectParameters() {
        self.ctrlViewController.duplicatePattern()
        XCTAssertEqual(self.mockPatternManagerLegal.createCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.createCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerLegal.modifiedPattern,
                       self.mockPatternManagerLegal.createdPattern)
    }
    
    func testDeletePattern_CorrectMethodsCalledWithCorrectParameters() {
        self.ctrlViewController.deletePattern()
        XCTAssertEqual(self.mockPatternManagerLegal.deleteCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerLegal.deleteCallers.first, self.id)
    }
}

class CtrlViewControllerSch3TestsIllegal: XCTestCase {
    let id = "1112"
    var ctrlViewController: CtrlViewControllerSch3!
    var mockPatternManagerIllegal: MockPatternManagerAlwaysIllegal!
    let testPattern1 = Pattern.init(speed: 25.0, direction: 1.78, blackWidth: 5.34, whiteWidth: 7.22)
    
    override func setUpWithError() throws {
        self.ctrlViewController = CtrlViewControllerSch3.init(id: self.id, frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), pattern: self.testPattern1)
        self.mockPatternManagerIllegal = MockPatternManagerAlwaysIllegal()
        self.ctrlViewController?.patternDelegate = self.mockPatternManagerIllegal
    }

    override func tearDownWithError() throws {
        self.ctrlViewController = nil
        self.mockPatternManagerIllegal = nil
    }
    
    func testModifyPattern_PatternNotNil_EndWithBlackAndWhiteWidth_CorrectMethodsCalledWithCorrectParametersAndPatternModifiedCorrectly() {
        let speedToSet: CGFloat = 25.465
        let directionToSet: CGFloat = 1.655
        let blackWidthToSet: CGFloat = 4.312
        let whiteWidthToSet: CGFloat = 6.998
        
        assert(!self.ctrlViewController.modifyPattern(speed: 22))
        assert(!self.ctrlViewController.modifyPattern(blackWidth: 6.45))
        assert(!self.ctrlViewController.modifyPattern(speed: speedToSet))
        assert(!self.ctrlViewController.modifyPattern(whiteWidth: 7.346))
        assert(!self.ctrlViewController.modifyPattern(direction: 0.765))
        assert(!self.ctrlViewController.modifyPattern(fillRatio: 0.845))
        assert(!self.ctrlViewController.modifyPattern(scaleFactor: 1.65))
        assert(!self.ctrlViewController.modifyPattern(whiteWidth: whiteWidthToSet))
        assert(!self.ctrlViewController.modifyPattern(blackWidth: blackWidthToSet))
        assert(!self.ctrlViewController.modifyPattern(direction: directionToSet))
        
        XCTAssertEqual(self.mockPatternManagerIllegal.modifySpeedCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifySpeedCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifyDirectionCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifyDirectionCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifyBlackWidthCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifyBlackWidthCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifyWhiteWidthCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifyWhiteWidthCallers.first, self.id)
    }
    
    func testModifyPattern_PatternNil_EndWithBlackAndWhiteWidth_NoError() {
        self.mockPatternManagerIllegal.doesReturnPatternControlled = false
        let speedToSet: CGFloat = 25.465
        let directionToSet: CGFloat = 1.655
        let blackWidthToSet: CGFloat = 4.312
        let whiteWidthToSet: CGFloat = 6.998
        
        assert(!self.ctrlViewController.modifyPattern(speed: 22))
        assert(!self.ctrlViewController.modifyPattern(blackWidth: 6.45))
        assert(!self.ctrlViewController.modifyPattern(speed: speedToSet))
        assert(!self.ctrlViewController.modifyPattern(whiteWidth: 7.346))
        assert(!self.ctrlViewController.modifyPattern(direction: 0.765))
        assert(!self.ctrlViewController.modifyPattern(fillRatio: 0.845))
        assert(!self.ctrlViewController.modifyPattern(scaleFactor: 1.65))
        assert(!self.ctrlViewController.modifyPattern(whiteWidth: whiteWidthToSet))
        assert(!self.ctrlViewController.modifyPattern(blackWidth: blackWidthToSet))
        assert(!self.ctrlViewController.modifyPattern(direction: directionToSet))
    }
    
    func testModifyPattern_PatternNotNil_EndWithScaleAndFill_CorrectMethodsCalledWithCorrectParametersAndPatternModifiedCorrectly() {
        let speedToSet: CGFloat = 24.071
        let directionToSet: CGFloat = 1.398
        let scaleFactorToSet: CGFloat = 3.456
        let fillRatioToSet: CGFloat = 0.455
        
        assert(!self.ctrlViewController.modifyPattern(speed: 21.543))
        assert(!self.ctrlViewController.modifyPattern(fillRatio: 0.88))
        assert(!self.ctrlViewController.modifyPattern(blackWidth: 7.937))
        assert(!self.ctrlViewController.modifyPattern(whiteWidth: 7.045))
        assert(!self.ctrlViewController.modifyPattern(scaleFactor: 3.232))
        assert(!self.ctrlViewController.modifyPattern(scaleFactor: scaleFactorToSet))
        assert(!self.ctrlViewController.modifyPattern(fillRatio: fillRatioToSet))
        assert(!self.ctrlViewController.modifyPattern(speed: speedToSet))
        assert(!self.ctrlViewController.modifyPattern(direction: 0.998))
        assert(!self.ctrlViewController.modifyPattern(direction: directionToSet))
        
        XCTAssertEqual(self.mockPatternManagerIllegal.modifySpeedCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifySpeedCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifyDirectionCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifyDirectionCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifyBlackWidthCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifyBlackWidthCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifyWhiteWidthCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.modifyWhiteWidthCallers.first, self.id)
    }
    
    func testModifyPattern_PatternNil_EndWithScaleAndFill_NoError() {
        self.mockPatternManagerIllegal.doesReturnPatternControlled = false
        let speedToSet: CGFloat = 24.071
        let directionToSet: CGFloat = 1.398
        let scaleFactorToSet: CGFloat = 3.456
        let fillRatioToSet: CGFloat = 0.455
        
        assert(!self.ctrlViewController.modifyPattern(speed: 21.543))
        assert(!self.ctrlViewController.modifyPattern(fillRatio: 0.88))
        assert(!self.ctrlViewController.modifyPattern(blackWidth: 7.937))
        assert(!self.ctrlViewController.modifyPattern(whiteWidth: 7.045))
        assert(!self.ctrlViewController.modifyPattern(scaleFactor: 3.232))
        assert(!self.ctrlViewController.modifyPattern(scaleFactor: scaleFactorToSet))
        assert(!self.ctrlViewController.modifyPattern(fillRatio: fillRatioToSet))
        assert(!self.ctrlViewController.modifyPattern(speed: speedToSet))
        assert(!self.ctrlViewController.modifyPattern(direction: 0.998))
        assert(!self.ctrlViewController.modifyPattern(direction: directionToSet))
    }
    
    func testChangeDisplayProperties_PatternNotNil_CorrectMethodsCalledWithCorrectParameters() {
        self.ctrlViewController.highlightPattern()
        self.ctrlViewController.dimPattern()
        assert(!self.ctrlViewController.hidePattern())
        self.ctrlViewController.unhidePattern()
        self.ctrlViewController.unhighlightPattern()
        self.ctrlViewController.undimPattern()

        XCTAssertEqual(self.mockPatternManagerIllegal.highlightCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.highlightCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerIllegal.unhighlightCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.unhighlightCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerIllegal.dimCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.dimCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerIllegal.undimCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.undimCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerIllegal.hideCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.hideCallers.first, self.id)
        XCTAssertEqual(self.mockPatternManagerIllegal.unhideCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.unhideCallers.first, self.id)
    }
    
    func testChangeDisplayProperties_PatternNil_NoError() {
        self.ctrlViewController.highlightPattern()
        self.ctrlViewController.dimPattern()
        assert(!self.ctrlViewController.hidePattern())
        self.ctrlViewController.unhidePattern()
        self.ctrlViewController.unhighlightPattern()
        self.ctrlViewController.undimPattern()
    }
    
    func testDuplicatePattern_PatternNotNil_CorrectMethodsCalledWithCorrectParameters() {
        self.ctrlViewController.duplicatePattern()
        XCTAssertEqual(self.mockPatternManagerIllegal.createCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.createCallers.first, self.id)
    }
    
    func testDuplicatePattern_PatternNil_CreateMethodsNotCalled() {
        self.mockPatternManagerIllegal.doesReturnPatternControlled = false
        self.ctrlViewController.duplicatePattern()
        XCTAssertEqual(self.mockPatternManagerIllegal.createCallers.count, 0)
    }
    
    func testDeletePattern_PatternNotNil_CorrectMethodsCalledWithCorrectParameters() {
        self.ctrlViewController.deletePattern()
        XCTAssertEqual(self.mockPatternManagerIllegal.deleteCallers.count, 1)
        XCTAssertEqual(self.mockPatternManagerIllegal.deleteCallers.first, self.id)
    }
    
    func testDeletePattern_PatternNil_NoError() {
        self.ctrlViewController.deletePattern()
    }
}
