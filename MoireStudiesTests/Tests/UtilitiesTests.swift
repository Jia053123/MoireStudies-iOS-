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
    
    func testIsWithinBoundsMoire() {
        let speedTooHigh: CGFloat = 99999
        assert(BoundsManager.speedRange.upperBound < speedTooHigh)

        let directionTooLow: CGFloat = -128.3
        assert(BoundsManager.directionRange.lowerBound > directionTooLow)

        let blackWidthTooHigh: CGFloat = 186745
        assert(BoundsManager.blackWidthRange.upperBound < blackWidthTooHigh)

        let whiteWidthTooLow: CGFloat = -1
        assert(BoundsManager.whiteWidthRange.lowerBound > whiteWidthTooLow)
        
        var p0 = Pattern.debugPattern()
        assert(Utilities.isWithinBounds(pattern: p0))
        var p1 = Pattern.debugPattern()
        assert(Utilities.isWithinBounds(pattern: p1))
        var p2 = Pattern.debugPattern()
        assert(Utilities.isWithinBounds(pattern: p2))
        var p3 = Pattern.debugPattern()
        assert(Utilities.isWithinBounds(pattern: p3))
        let p4 = Pattern.debugPattern()
        assert(Utilities.isWithinBounds(pattern: p4))
        let p5 = Pattern.debugPattern()
        assert(Utilities.isWithinBounds(pattern: p5))
        
        p0.speed = speedTooHigh
        p1.direction = directionTooLow
        p2.blackWidth = blackWidthTooHigh
        p3.whiteWidth = whiteWidthTooLow
        
        let outofBoundM = Moire()
        outofBoundM.patterns = [p0, p1, p2, p3, p4]
        XCTAssertFalse(Utilities.isWithinBounds(moire: outofBoundM))
        
        let withinBoundM = Moire()
        withinBoundM.patterns = [p4, p5]
        XCTAssertTrue(Utilities.isWithinBounds(moire: withinBoundM))
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
                            assert(BoundsManager.directionRange.contains(expectedResult))
                            XCTAssertEqual(fittedPattern.direction, expectedResult)
                        } else if d < BoundsManager.directionRange.lowerBound {
                            var expectedResult = patternToTest.direction
                            while expectedResult < BoundsManager.directionRange.lowerBound {
                                expectedResult += 2*CGFloat.pi
                            }
                            assert(BoundsManager.directionRange.contains(expectedResult))
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
    
    func testFitWithinBoundsMoire() {
        let speedTooHigh: CGFloat = 99999
        assert(BoundsManager.speedRange.upperBound < speedTooHigh)

        let directionTooLow: CGFloat = -128.3
        assert(BoundsManager.directionRange.lowerBound > directionTooLow)

        let blackWidthTooHigh: CGFloat = 186745
        assert(BoundsManager.blackWidthRange.upperBound < blackWidthTooHigh)

        let whiteWidthTooLow: CGFloat = -1
        assert(BoundsManager.whiteWidthRange.lowerBound > whiteWidthTooLow)
        
        var p0 = Pattern.debugPattern()
        assert(Utilities.isWithinBounds(pattern: p0))
        var p1 = Pattern.debugPattern()
        assert(Utilities.isWithinBounds(pattern: p1))
        var p2 = Pattern.debugPattern()
        assert(Utilities.isWithinBounds(pattern: p2))
        var p3 = Pattern.debugPattern()
        assert(Utilities.isWithinBounds(pattern: p3))
        let p4 = Pattern.debugPattern()
        assert(Utilities.isWithinBounds(pattern: p4))
        
        p0.speed = speedTooHigh
        p1.direction = directionTooLow
        p2.blackWidth = blackWidthTooHigh
        p3.whiteWidth = whiteWidthTooLow
        
        let m = Moire()
        m.patterns = [p0, p1, p2, p3, p4]
        let fittedM = Utilities.fitWithinBounds(moire: m)
        XCTAssertEqual(fittedM.patterns[0], Utilities.fitWithinBounds(pattern: p0))
        XCTAssertEqual(fittedM.patterns[1], Utilities.fitWithinBounds(pattern: p1))
        XCTAssertEqual(fittedM.patterns[2], Utilities.fitWithinBounds(pattern: p2))
        XCTAssertEqual(fittedM.patterns[3], Utilities.fitWithinBounds(pattern: p3))
        XCTAssertEqual(fittedM.patterns[4], p4)
    }
    
    func testIntersectRanges_HasIntersection_ReturnIntersection() {
        let r11 = 0...5
        let r21 = 2...8
        let intersection1 = 2...5
        XCTAssertEqual(Utilities.intersectRanges(range1: r11, range2: r21), intersection1)
        XCTAssertEqual(Utilities.intersectRanges(range1: r21, range2: r11), intersection1)
        
        let r12 = -1.1...5.4
        let r22 = 1.2...3.2
        let intersection2 = 1.2...3.2
        XCTAssertEqual(Utilities.intersectRanges(range1: r12, range2: r22), intersection2)
        XCTAssertEqual(Utilities.intersectRanges(range1: r22, range2: r12), intersection2)
        
        let r13 = -5.3 ... -1.11
        let r23 = -10.1 ... -0.9
        let intersection3 = -5.3 ... -1.11
        XCTAssertEqual(Utilities.intersectRanges(range1: r13, range2: r23), intersection3)
        XCTAssertEqual(Utilities.intersectRanges(range1: r23, range2: r13), intersection3)
        
        let r14 = 0...5
        let r24 = 5...10
        let intersection4 = 5...5
        XCTAssertEqual(Utilities.intersectRanges(range1: r14, range2: r24), intersection4)
        XCTAssertEqual(Utilities.intersectRanges(range1: r24, range2: r14), intersection4)
    }
    
    func testIntersectRanges_NoIntersection_ReturnNil() {
        let r11 = -1.5...3.2
        let r12 = 3.3...5.0
        XCTAssertNil(Utilities.intersectRanges(range1: r11, range2: r12))
        XCTAssertNil(Utilities.intersectRanges(range1: r12, range2: r11))
    }
}
