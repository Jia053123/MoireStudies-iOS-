//
//  MatcherTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-04-26.
//

@testable import MoireStudies
import XCTest
import UIKit

class CtrlAndPatternMatcherTests: XCTestCase {
    var ctrlAndPatternMatcher: CtrlAndPatternMatcher?
    override func setUpWithError() throws {
        self.ctrlAndPatternMatcher = CtrlAndPatternMatcher()
    }
    override func tearDownWithError() throws {
        self.ctrlAndPatternMatcher = nil
    }

    func testConvertingIndexesToIdBackAndForth() {
        XCTAssertEqual(self.ctrlAndPatternMatcher!.getOrCreateCtrlViewControllerId(indexesOfPatternControlled: [1]), "/1")
        XCTAssertEqual(self.ctrlAndPatternMatcher!.getIndexesOfPatternControlled(controllerId: "/1"), [1])
        
        XCTAssertEqual(self.ctrlAndPatternMatcher!.getOrCreateCtrlViewControllerId(indexesOfPatternControlled: [1,2]), "/1/2")
        XCTAssertEqual(self.ctrlAndPatternMatcher!.getIndexesOfPatternControlled(controllerId: "/1/2"),[1,2])

        XCTAssertEqual(self.ctrlAndPatternMatcher!.getOrCreateCtrlViewControllerId(indexesOfPatternControlled: [12]), "/12")
        XCTAssertEqual(self.ctrlAndPatternMatcher!.getIndexesOfPatternControlled(controllerId: "/12"),[12])

        XCTAssertEqual(self.ctrlAndPatternMatcher!.getOrCreateCtrlViewControllerId(indexesOfPatternControlled: [12, 6, 998]), "/12/6/998")
        XCTAssertEqual(self.ctrlAndPatternMatcher!.getIndexesOfPatternControlled(controllerId: "/12/6/998"),[12, 6, 998])

        XCTAssertEqual(self.ctrlAndPatternMatcher!.getIndexesOfPatternControlled(controllerId: ""),nil)
        XCTAssertEqual(self.ctrlAndPatternMatcher!.getIndexesOfPatternControlled(controllerId: "/98"),nil)
        XCTAssertEqual(self.ctrlAndPatternMatcher!.getIndexesOfPatternControlled(controllerId: "1"),nil)
        XCTAssertEqual(self.ctrlAndPatternMatcher!.getIndexesOfPatternControlled(controllerId: "/-1"),nil)
        XCTAssertEqual(self.ctrlAndPatternMatcher!.getIndexesOfPatternControlled(controllerId: "abc"),nil)
        XCTAssertEqual(self.ctrlAndPatternMatcher!.getIndexesOfPatternControlled(controllerId: "/1/22/abc"),nil)
    }
}
