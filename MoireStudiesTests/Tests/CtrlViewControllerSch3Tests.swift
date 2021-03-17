//
//  BasicCtrlViewControllerTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-05.
//

@testable import MoireStudies
import XCTest
import UIKit

class CtrlViewControllerSch3TestsLegal: XCTestCase {
    let id = 1111
    var ctrlViewController: CtrlViewControllerSch3!
    var mockPatternManagerLegal: MockPatternManagerLegal!
    let testPattern1 = Pattern.init(speed: 25.0, direction: 1.78, blackWidth: 5.34, whiteWidth: 7.22)
    var testPattern1Copy: Pattern?
    
    override func setUpWithError() throws {
        assert(Utilities.isWithinBounds(pattern: testPattern1))
        self.testPattern1Copy = self.testPattern1
        self.ctrlViewController = CtrlViewControllerSch3.init(id: self.id, frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), pattern: self.testPattern1)
        self.mockPatternManagerLegal = MockPatternManagerLegal()
        self.mockPatternManagerLegal!.setCurrentPatternControlled(initPattern: self.testPattern1)
        self.ctrlViewController?.delegate = self.mockPatternManagerLegal
    }

    override func tearDownWithError() throws {
        self.ctrlViewController = nil
        self.mockPatternManagerLegal = nil
        self.testPattern1Copy = nil
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
        assert(self.ctrlViewController.modifyPattern(scaleFactor: 3.232))
        assert(self.ctrlViewController.modifyPattern(scaleFactor: scaleFactorToSet))
        assert(self.ctrlViewController.modifyPattern(fillRatio: fillRatioToSet))
        assert(self.ctrlViewController.modifyPattern(speed: speedToSet))
        assert(self.ctrlViewController.modifyPattern(direction: 0.998))
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
}

class CtrlViewControllerSch3TestsIlligal: XCTestCase {
    var ctrlViewController: CtrlViewControllerSch3?
    var mockPatternManagerIllegal: MockPatternManagerIllegal?
}
