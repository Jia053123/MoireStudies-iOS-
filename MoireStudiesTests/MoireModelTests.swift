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
        let moireModel = MoireModel()
        let success = moireModel.deleteAllSaves()
        XCTAssert(success == true)
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
    
    func testDeleteMoires() throws {
        let moireModel1 = MoireModel()
        
        let count0 = moireModel1.numOfMoires()
        XCTAssert(count0 == 0, String(format: "current count: %d", count0))
        
        let m1 = moireModel1.createNew()
        let m2 = moireModel1.createNew()
        let m3 = moireModel1.createNew()
        let count1 = moireModel1.numOfMoires()
        XCTAssert(count1 == 3, String(format: "current count: %d", count1))
        
//        let r1 = moireModel1.delete(moireId: m2.id)
    }
    
    func testSaveAndUpdateMoires() throws {
        
    }
    
    func testMultipleOperations() throws {
        
    }
}
