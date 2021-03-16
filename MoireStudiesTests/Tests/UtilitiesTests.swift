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
}
