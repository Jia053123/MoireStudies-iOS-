//
//  CtrlViewControllerSch2Tests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-01-04.
//

import XCTest
@testable import MoireStudies

class UtilitiesTests: XCTestCase { // TODO: test more cases
    
    func testConvertToFillRatioAndScaleFactor() {
        let result1 = Utilities.convertToFillRatioAndScaleFactor(blackWidth: 10.0, whiteWidth: 10.0)
        XCTAssert(abs(result1.fillRatio - 0.5) < 0.001, String(format: "fillRatio wrong: %f", result1.fillRatio))
        XCTAssert(abs(result1.scaleFactor - 20.0 / Constants.UI.tileHeight) < 0.001,
                  String(format: "scaleFactor wrong: %f", result1.scaleFactor))
        
        let result2 = Utilities.convertToFillRatioAndScaleFactor(blackWidth: 10, whiteWidth: 40)
        XCTAssert(abs(result2.fillRatio - 0.2) < 0.001, String(format: "fillRatio wrong: %f", result2.fillRatio))
        XCTAssert(abs(result2.scaleFactor - 50.0 / Constants.UI.tileHeight) < 0.001,
                  String(format: "scaleFactor wrong: %f", result2.scaleFactor))
    }
    
    func testConvertToBlackWidthAndWhiteWidth() {
        let result1 = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: 0.5, scaleFactor: 20.0 / Constants.UI.tileHeight)
        XCTAssert(abs(result1.blackWidth - 10.0) < 0.001, String(format: "blackWidth wrong: %f", result1.blackWidth))
        XCTAssert(abs(result1.whiteWidth - 10.0) < 0.001, String(format: "whiteWidth wrong: %f", result1.whiteWidth))
        
        let result2 = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: 0.2, scaleFactor: 50.0 / Constants.UI.tileHeight)
        XCTAssert(abs(result2.blackWidth - 10.0) < 0.001, String(format: "blackWidth wrong: %f", result2.blackWidth))
        XCTAssert(abs(result2.whiteWidth - 40.0) < 0.001, String(format: "whiteWidth wrong: %f", result2.whiteWidth))
    }
    
    func testIsWithinBounds() {
        let speedValid: CGFloat = 15.887
        assert(BoundsManager.speedRange.contains(speedValid))
        let speedTooHigh: CGFloat = 99999
        assert(BoundsManager.speedRange.upperBound < speedTooHigh)
        let speedTooLow: CGFloat = -99999
        assert(BoundsManager.speedRange.lowerBound > speedTooLow)
        
        let directionValid: CGFloat = 1.398
        assert(BoundsManager.directionRange.contains(directionValid))
        let directionTooHigh: CGFloat = 59.65
        assert(BoundsManager.directionRange.upperBound < directionTooHigh)
        let directionTooLow: CGFloat = -128.3
        assert(BoundsManager.directionRange.lowerBound > directionTooLow)
        
        let blackWidthValid: CGFloat = 7.267
        assert(BoundsManager.blackWidthRange.contains(blackWidthValid))
        let blackWidthTooHigh: CGFloat = 186745
        assert(BoundsManager.blackWidthRange.upperBound < blackWidthTooHigh)
        let blackWidthTooLow: CGFloat = 0
        assert(BoundsManager.blackWidthRange.lowerBound > blackWidthTooLow)
        
        let whiteWidthValid: CGFloat = 6.445
        assert(BoundsManager.whiteWidthRange.contains(whiteWidthValid))
        let whiteWidthTooHigh: CGFloat = 64593
        assert(BoundsManager.whiteWidthRange.upperBound < whiteWidthTooHigh)
        let whiteWidthTooLow: CGFloat = -1
        assert(BoundsManager.whiteWidthRange.lowerBound > whiteWidthTooLow)
        
        XCTAssertTrue(Utilities.isWithinBounds(pattern: Pattern.init(speed: speedValid,
                                                                     direction: directionValid,
                                                                     blackWidth: blackWidthValid,
                                                                     whiteWidth: whiteWidthValid)))
        let speeds = [speedValid, speedTooLow, speedTooHigh]
        let directions = [directionValid, directionTooLow, directionTooHigh]
        let blackWidth = [blackWidthValid, blackWidthTooLow, blackWidthTooHigh]
        let whiteWidth = [whiteWidthValid, whiteWidthTooLow, whiteWidthTooHigh]
        
        for s in speeds {
            for d in directions {
                for b in blackWidth {
                    for w in whiteWidth {
                        if s == speedValid && d == directionValid && b == blackWidthValid && w == whiteWidthValid {
                            continue
                        } else {
                            XCTAssertFalse(Utilities.isWithinBounds(pattern: Pattern.init(speed: s,
                                                                                          direction: d,
                                                                                          blackWidth: b,
                                                                                          whiteWidth: w)))
                        }
                    }
                }
            }
        }
    }
    
    func testFitWithinBounds() {
        let speedValid: CGFloat = 15.887
        assert(BoundsManager.speedRange.contains(speedValid))
        let speedTooHigh: CGFloat = 99999
        assert(BoundsManager.speedRange.upperBound < speedTooHigh)
        let speedTooLow: CGFloat = -99999
        assert(BoundsManager.speedRange.lowerBound > speedTooLow)

        let directionValid: CGFloat = 1.398
        assert(BoundsManager.directionRange.contains(directionValid))
        let directionTooHigh: CGFloat = 59.65
        assert(BoundsManager.directionRange.upperBound < directionTooHigh)
        let directionTooLow: CGFloat = -128.3
        assert(BoundsManager.directionRange.lowerBound > directionTooLow)

        let blackWidthValid: CGFloat = 7.267
        assert(BoundsManager.blackWidthRange.contains(blackWidthValid))
        let blackWidthTooHigh: CGFloat = 186745
        assert(BoundsManager.blackWidthRange.upperBound < blackWidthTooHigh)
        let blackWidthTooLow: CGFloat = 0
        assert(BoundsManager.blackWidthRange.lowerBound > blackWidthTooLow)

        let whiteWidthValid: CGFloat = 6.445
        assert(BoundsManager.whiteWidthRange.contains(whiteWidthValid))
        let whiteWidthTooHigh: CGFloat = 64593
        assert(BoundsManager.whiteWidthRange.upperBound < whiteWidthTooHigh)
        let whiteWidthTooLow: CGFloat = -1
        assert(BoundsManager.whiteWidthRange.lowerBound > whiteWidthTooLow)

        let speeds = [speedValid, speedTooLow, speedTooHigh]
        let directions = [directionValid, directionTooLow, directionTooHigh]
        let blackWidth = [blackWidthValid, blackWidthTooLow, blackWidthTooHigh]
        let whiteWidth = [whiteWidthValid, whiteWidthTooLow, whiteWidthTooHigh]
        
        for s in speeds {
            for d in directions {
                for b in blackWidth {
                    for w in whiteWidth {
                        let patternToTest = Pattern.init(speed: s,direction: d, blackWidth: b, whiteWidth: w)
                        let fittedPattern = Utilities.fitWithinBounds(pattern: patternToTest)
                        
                        if s > BoundsManager.speedRange.upperBound {
                            XCTAssertEqual(fittedPattern.speed, BoundsManager.speedRange.upperBound)
                        } else if s < BoundsManager.speedRange.lowerBound {
                            XCTAssertEqual(fittedPattern.speed, BoundsManager.speedRange.lowerBound)
                        } else {
                            XCTAssertEqual(fittedPattern.speed, patternToTest.speed)
                        }
                        
                        if d > BoundsManager.directionRange.upperBound {
                            var expectedResult = patternToTest.direction
                            while expectedResult > BoundsManager.directionRange.upperBound {
                                expectedResult -= 2*CGFloat.pi
                            }
                            XCTAssertEqual(fittedPattern.direction, expectedResult)
                        } else if d < BoundsManager.directionRange.lowerBound {
                            var expectedResult = patternToTest.direction
                            while expectedResult < BoundsManager.directionRange.lowerBound {
                                expectedResult += 2*CGFloat.pi
                            }
                            XCTAssertEqual(fittedPattern.direction, expectedResult)
                        } else {
                            XCTAssertEqual(fittedPattern.direction, patternToTest.direction)
                        }
                        
                        if b > BoundsManager.blackWidthRange.upperBound {
                            XCTAssertEqual(fittedPattern.blackWidth, BoundsManager.blackWidthRange.upperBound)
                        } else if b < BoundsManager.blackWidthRange.lowerBound {
                            XCTAssertEqual(fittedPattern.blackWidth, BoundsManager.blackWidthRange.lowerBound)
                        } else {
                            XCTAssertEqual(fittedPattern.blackWidth, patternToTest.blackWidth)
                        }
                        
                        if w > BoundsManager.whiteWidthRange.upperBound {
                            XCTAssertEqual(fittedPattern.whiteWidth, BoundsManager.whiteWidthRange.upperBound)
                        } else if w < BoundsManager.whiteWidthRange.lowerBound {
                            XCTAssertEqual(fittedPattern.whiteWidth, BoundsManager.whiteWidthRange.lowerBound)
                        } else {
                            XCTAssertEqual(fittedPattern.whiteWidth, patternToTest.whiteWidth)
                        }
                    }
                }
            }
        }
    }
}
