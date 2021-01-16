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
        var count: Int
        let moireModel1 = MoireModel()
        
        count = moireModel1.numOfMoires()
        XCTAssert(count == 0, String(format: "current count: %d", count))
        
        _ = moireModel1.createNew()
        count = moireModel1.numOfMoires()
        XCTAssert(count == 1, String(format: "current count: %d", count))
        
        _ = moireModel1.createNew()
        _ = moireModel1.createNew()
        count = moireModel1.numOfMoires()
        XCTAssert(count == 3, String(format: "current count: %d", count))
        
        _ = moireModel1.createNew()
        let moireModel2 = MoireModel()
        count = moireModel2.numOfMoires()
        XCTAssert(count == 4, String(format: "current count: %d", count))
    }
    
    func testDeleteMoires() throws {
        var count: Int
        var success: Bool
        let moireModel1 = MoireModel()
        
        count = moireModel1.numOfMoires()
        XCTAssert(count == 0, String(format: "current count: %d", count))
        
        let m1 = moireModel1.createNew()
        let m2 = moireModel1.createNew()
        let m3 = moireModel1.createNew()
        count = moireModel1.numOfMoires()
        XCTAssert(count == 3, String(format: "current count: %d", count))
        
        success = moireModel1.delete(moireId: m2.id)
        XCTAssert(success == true)
        count = moireModel1.numOfMoires()
        XCTAssert(count == 2, String(format: "current count: %d", count))
        
        success = moireModel1.delete(moireId: m1.id)
        XCTAssert(success == true)
        count = moireModel1.numOfMoires()
        XCTAssert(count == 1, String(format: "current count: %d", count))
        
        success = moireModel1.delete(moireId: m1.id)
        XCTAssert(success == false)
        count = moireModel1.numOfMoires()
        XCTAssert(count == 1, String(format: "current count: %d", count))
        
        success = moireModel1.delete(moireId: m3.id)
        XCTAssert(success == true)
        count = moireModel1.numOfMoires()
        XCTAssert(count == 0, String(format: "current count: %d", count))
        
        success = moireModel1.delete(moireId: m3.id)
        XCTAssert(success == false)
        count = moireModel1.numOfMoires()
        XCTAssert(count == 0, String(format: "current count: %d", count))
    }
    
    func testSaveAndUpdateMoires() throws {
        
    }
}
