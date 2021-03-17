//
//  CtrlAndPatternMatcherTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-05.
//

@testable import MoireStudies
import Foundation
import XCTest

class CtrlAndPatternMatcherTests: XCTestCase {
    var matcher: CtrlAndPatternMatcher!
    
    override func setUpWithError() throws {
        matcher = CtrlAndPatternMatcher()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetViewControllerId() throws {
        
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
