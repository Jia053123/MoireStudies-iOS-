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
        assert(Constants.Bounds.speedRange.contains(speedValid))
        let speedTooHigh: CGFloat = 99999
        assert(Constants.Bounds.speedRange.upperBound < speedTooHigh)
        let speedTooLow: CGFloat = -99999
        assert(Constants.Bounds.speedRange.lowerBound > speedTooLow)
        
        let directionValid: CGFloat = 1.398
        assert(Constants.Bounds.directionRange.contains(directionValid))
        let directionTooHigh: CGFloat = 59.65
        assert(Constants.Bounds.directionRange.upperBound < directionTooHigh)
        let directionTooLow: CGFloat = -128.3
        assert(Constants.Bounds.directionRange.lowerBound > directionTooLow)
        
        let blackWidthValid: CGFloat = 7.267
        assert(Constants.Bounds.blackWidthRange.contains(blackWidthValid))
        let blackWidthTooHigh: CGFloat = 186745
        assert(Constants.Bounds.blackWidthRange.upperBound < blackWidthTooHigh)
        let blackWidthTooLow: CGFloat = 0
        assert(Constants.Bounds.blackWidthRange.lowerBound > blackWidthTooLow)
        
        let whiteWidthValid: CGFloat = 6.445
        assert(Constants.Bounds.whiteWidthRange.contains(whiteWidthValid))
        let whiteWidthTooHigh: CGFloat = 64593
        assert(Constants.Bounds.whiteWidthRange.upperBound < whiteWidthTooHigh)
        let whiteWidthTooLow: CGFloat = -1
        assert(Constants.Bounds.whiteWidthRange.lowerBound > whiteWidthTooLow)
        
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
}
