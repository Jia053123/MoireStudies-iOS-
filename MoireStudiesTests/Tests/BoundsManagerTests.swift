//
//  BoundsManagerTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-25.
//

import XCTest
@testable import MoireStudies

class BoundsManagerTests: XCTestCase {
    private func testOutputBoundsNeitherTooLiberalNorTooStrict(blackWidth: CGFloat, whiteWidth: CGFloat) {
        let result = BoundsManager.calcBoundsForFillRatioAndScaleFactor(blackWidth: blackWidth, whiteWidth: whiteWidth)
        XCTAssertNotNil(result)
        let minFR = result!.fillRatioRange.lowerBound
        let maxFR = result!.fillRatioRange.upperBound
        let currentSF = Utilities.convertToFillRatioAndScaleFactor(blackWidth: blackWidth, whiteWidth: whiteWidth).scaleFactor
        let rMinFR = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: minFR, scaleFactor: currentSF)
        let rMaxFR = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: maxFR, scaleFactor: currentSF)
        // the bounds cannot be too liberal (the widths must stay valid)
        XCTAssertTrue(BoundsManager.blackWidthRange.contains(rMinFR.blackWidth))
        XCTAssertTrue(BoundsManager.blackWidthRange.contains(rMaxFR.blackWidth))
        XCTAssertTrue(BoundsManager.whiteWidthRange.contains(rMinFR.whiteWidth))
        XCTAssertTrue(BoundsManager.whiteWidthRange.contains(rMaxFR.whiteWidth))
        // the bounds cannot be too strict (one of the widths must be near its limit)
        XCTAssertTrue(abs(rMinFR.blackWidth - BoundsManager.blackWidthRange.lowerBound) < 0.001 ||
                        abs(rMinFR.whiteWidth - BoundsManager.whiteWidthRange.upperBound) < 0.001)
        XCTAssertTrue(abs(rMaxFR.blackWidth - BoundsManager.blackWidthRange.upperBound) < 0.001 ||
                        abs(rMaxFR.whiteWidth - BoundsManager.whiteWidthRange.lowerBound) < 0.001)
        
        let minSF = result!.scaleFactorRange.lowerBound
        let maxSF = result!.scaleFactorRange.upperBound
        let currentFR = Utilities.convertToFillRatioAndScaleFactor(blackWidth: blackWidth, whiteWidth: whiteWidth).fillRatio
        let rMinSF = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: currentFR, scaleFactor: minSF)
        let rMaxSF = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: currentFR, scaleFactor: maxSF)
        // the bounds cannot be too liberal (the widths must stay valid)
        XCTAssertTrue(BoundsManager.blackWidthRange.contains(rMinSF.blackWidth))
        XCTAssertTrue(BoundsManager.blackWidthRange.contains(rMaxSF.blackWidth))
        XCTAssertTrue(BoundsManager.whiteWidthRange.contains(rMinSF.whiteWidth))
        XCTAssertTrue(BoundsManager.whiteWidthRange.contains(rMaxSF.whiteWidth))
        // the bounds cannot be too strict (one of the widths must be near its limit)
        XCTAssertTrue(abs(rMinSF.blackWidth - BoundsManager.blackWidthRange.lowerBound) < 0.001 ||
                        abs(rMinSF.whiteWidth - BoundsManager.whiteWidthRange.lowerBound) < 0.001)
        XCTAssertTrue(abs(rMaxSF.blackWidth - BoundsManager.blackWidthRange.upperBound) < 0.001 ||
                        abs(rMaxSF.whiteWidth - BoundsManager.whiteWidthRange.upperBound) < 0.001)
    }
    
    func testFindingTheExactBounds_OutputBoundsNeitherTooLiberalNorTooStrict() {
        let typicalBlackWidth: CGFloat = 10.234
        assert(BoundsManager.blackWidthRange.contains(typicalBlackWidth))
        let typicalWhiteWidth: CGFloat = 11.865
        assert(BoundsManager.whiteWidthRange.contains(typicalWhiteWidth))
        self.testOutputBoundsNeitherTooLiberalNorTooStrict(blackWidth: typicalBlackWidth, whiteWidth: typicalWhiteWidth)
    }
}
