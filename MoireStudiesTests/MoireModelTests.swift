//
//  SaveFileIOTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-01-13.
//

import Foundation
import XCTest

@testable import MoireStudies

class MoireModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testCreateMoires() throws {
        let moireModel1 = MoireModel()
        
        let count0 = moireModel1.numOfMoires()
        XCTAssert(count0 == 0, String(format: "current count: %d", count0))
        
        _ = moireModel1.createNew()
        let count1 = moireModel1.numOfMoires()
        XCTAssert(count1 == 1, String(format: "current count: %d", count1))
        
        _ = moireModel1.createNew()
        _ = moireModel1.createNew()
        let count2 = moireModel1.numOfMoires()
        XCTAssert(count2 == 3, String(format: "current count: %d", count2))
        
        _ = moireModel1.createNew()
        let moireModel2 = MoireModel()
        let count3 = moireModel2.numOfMoires()
        XCTAssert(count3 == 4, String(format: "current count: %d", count3))
    }
    
    func testSaveAndUpdateMoires() throws {
        
    }
    
    func testDeleteMoires() throws {

    }
    
    func testMultipleOperations() throws {
        
    }
}
