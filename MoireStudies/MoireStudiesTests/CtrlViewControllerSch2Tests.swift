//
//  CtrlViewControllerSch2Tests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-01-04.
//

import XCTest
@testable import MoireStudies

class CtrlViewControllerSch2Tests: XCTestCase {
    var controllerSch2: CtrlViewControllerSch2 = CtrlViewControllerSch2.init(id: 0, frame: CGRect.zero, pattern: Pattern.defaultPattern())

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testConvertToFillRatioAndScaleFactor() {
        let result1 = controllerSch2.convertToFillRatioAndScaleFactor(blackWidth: 10, whiteWidth: 10)
        XCTAssert(result1.fillRatio == 0.5, String(format: "fillRatio wrong: %f", result1.fillRatio))
        XCTAssert(result1.scaleFactor == 2.5, String(format: "scaleFactor wrong: %f", result1.scaleFactor))
        
        let result2 = controllerSch2.convertToFillRatioAndScaleFactor(blackWidth: 10, whiteWidth: 40)
        XCTAssert(result2.fillRatio == 0.2, String(format: "fillRatio wrong: %f", result2.fillRatio))
        XCTAssert(result2.scaleFactor == 6.25, String(format: "scaleFactor wrong: %f", result2.scaleFactor))
    }
    
    func testConvertToBlackWidthAndWhiteWidth() {
        let result1 = controllerSch2.convertToBlackWidthAndWhiteWidth(fillRatio: 0.5, scaleFactor: 2.5)
        XCTAssert(result1.blackWidth == 10.0, String(format: "blackWidth wrong: %f", result1.blackWidth))
        XCTAssert(result1.whiteWidth == 10.0, String(format: "whiteWidth wrong: %f", result1.whiteWidth))
        
        let result2 = controllerSch2.convertToBlackWidthAndWhiteWidth(fillRatio: 0.2, scaleFactor: 6.25)
        XCTAssert(result2.blackWidth == 10.0, String(format: "blackWidth wrong: %f", result2.blackWidth))
        XCTAssert(result2.whiteWidth == 40.0, String(format: "whiteWidth wrong: %f", result2.whiteWidth))
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
