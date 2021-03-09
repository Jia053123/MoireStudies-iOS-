//
//  SaveFileIOTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-01-13.
//

import Foundation
import XCTest
@testable import MoireStudies

class LocalMoireModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        let moireModel = LocalMoireModel()
        let success = moireModel.deleteAllSaves()
        XCTAssert(success == true)
    }
    
    func testCreateNewAndDataPersistance() throws {
        var count: Int
        let moireModel1 = LocalMoireModel()
        
        count = moireModel1.numOfMoires()
        XCTAssert(count == 0, String(format: "current count: %d", count))
        
        _ = moireModel1.createNewDemoMoire()
        count = moireModel1.numOfMoires()
        XCTAssert(count == 1, String(format: "current count: %d", count))
        
        _ = moireModel1.createNewEmptyMoire()
        _ = moireModel1.createNewDemoMoire()
        count = moireModel1.numOfMoires()
        XCTAssert(count == 3, String(format: "current count: %d", count))
        
        _ = moireModel1.createNewEmptyMoire()
        let moireModel2 = LocalMoireModel()
        count = moireModel2.numOfMoires()
        XCTAssert(count == 4, String(format: "current count: %d", count))
    }
    
    func testDelete() throws {
        var count: Int
        var success: Bool
        let moireModel1 = LocalMoireModel()
        
        count = moireModel1.numOfMoires()
        XCTAssert(count == 0, String(format: "current count: %d", count))
        
        let m1 = moireModel1.createNewEmptyMoire()
        let m2 = moireModel1.createNewDemoMoire()
        let m3 = moireModel1.createNewDemoMoire()
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
    
    func testSaveAndRead() throws {
        var success: Bool
        let moireModel1 = LocalMoireModel()
        
        let m1 = moireModel1.createNewDemoMoire()
        assert(m1.patterns[1].direction != 1.531)
        m1.patterns[1].direction = 1.531
        let i1 = m1.id
        success = moireModel1.saveOrModify(moire: m1)
        XCTAssert(success == true)
        
        let m2 = Moire()
        m2.patterns.append(Pattern.demoPattern1())
        m2.patterns.append(Pattern.demoPattern2())
        assert(m2.patterns[0].blackWidth != 5.129)
        m2.patterns[0].blackWidth = 5.129
        let i2 = m2.id
        success = moireModel1.saveOrModify(moire: m2)
        XCTAssert(success == true)
        
        let m3 = moireModel1.createNewEmptyMoire()
        m3.patterns.append(Pattern.demoPattern1())
        m3.patterns.append(Pattern.demoPattern2())
        assert(m3.patterns[0].direction != 1.532)
        m3.patterns[0].direction = 1.532
        let i3 = m3.id
        success = moireModel1.saveOrModify(moire: m3)
        XCTAssert(success == true)
        
        let m11 = moireModel1.read(moireId: i1)
        XCTAssert(m11 != nil)
        XCTAssert(m11!.patterns[1].direction == 1.531)
        let m21 = moireModel1.read(moireId: i2)
        XCTAssert(m21 != nil)
        XCTAssert(m21?.patterns[0].blackWidth == 5.129)
        let m31 = moireModel1.read(moireId: i3)
        XCTAssert(m31 != nil)
        XCTAssert(m31?.patterns[0].direction == 1.532)
        
        success = moireModel1.delete(moireId: i1)
        XCTAssert(success == true)
        let m12 = moireModel1.read(moireId: i1)
        XCTAssert(m12 == nil)
        let m22 = moireModel1.read(moireId: i2)
        XCTAssert(m22 != nil)
        XCTAssert(m22?.patterns[0].blackWidth == 5.129)
        let m32 = moireModel1.read(moireId: i3)
        XCTAssert(m32 != nil)
        XCTAssert(m32?.patterns[0].direction == 1.532)
    }
    
    func testReadAllMoiresAndReadLastCreatedOrEdited() {
        var success: Bool
        var ms1: Array<Moire>
        var ms2: Array<Moire>
        var m: Moire?
        var ids: Array<String>
        let moireModel1 = LocalMoireModel()
        
        ms1 = moireModel1.readAllMoiresSortedByLastCreatedOrModified()
        XCTAssert(ms1.count == 0)
        ms2 = moireModel1.readAllMoiresSortedByLastCreated()
        XCTAssert(ms2.count == 0)
        
        let m1 = moireModel1.createNewDemoMoire()
        let i1 = m1.id
        let m2 = moireModel1.createNewDemoMoire()
        let i2 = m2.id
        let m3 = moireModel1.createNewDemoMoire()
        let i3 = m3.id
        
        ms1 = moireModel1.readAllMoiresSortedByLastCreatedOrModified()
        XCTAssert(ms1.count == 3)
        ids = ms1.compactMap({$0.id})
        XCTAssert(ids.contains(i1))
        XCTAssert(ids.contains(i2))
        XCTAssert(ids.contains(i3))
        XCTAssert(ids == [i1,i2,i3])
        ms2 = moireModel1.readAllMoiresSortedByLastCreated()
        XCTAssert(ms2.count == 3)
        ids = ms2.compactMap({$0.id})
        XCTAssert(ids.contains(i1))
        XCTAssert(ids.contains(i2))
        XCTAssert(ids.contains(i3))
        XCTAssert(ids == [i1,i2,i3])
        m = moireModel1.readLastCreatedOrEdited()
        XCTAssert(m != nil)
        XCTAssert(m?.id == i3)
        
        assert(m2.patterns[0].blackWidth != 5.129)
        m2.patterns[0].blackWidth = 5.129
        success = moireModel1.saveOrModify(moire: m2)
        assert(success == true)
        ms1 = moireModel1.readAllMoiresSortedByLastCreatedOrModified()
        ids = ms1.compactMap({$0.id})
        XCTAssert(ids == [i1,i3,i2])
        ms2 = moireModel1.readAllMoiresSortedByLastCreated()
        ids = ms2.compactMap({$0.id})
        XCTAssert(ids == [i1,i2,i3])
        m = moireModel1.readLastCreatedOrEdited()
        XCTAssert(m != nil)
        XCTAssert(m?.id == i2)
        
        let m4 = moireModel1.createNewDemoMoire()
        let i4 = m4.id
        ms1 = moireModel1.readAllMoiresSortedByLastCreatedOrModified()
        ids = ms1.compactMap({$0.id})
        XCTAssert(ids == [i1,i3,i2,i4])
        ms2 = moireModel1.readAllMoiresSortedByLastCreated()
        ids = ms2.compactMap({$0.id})
        XCTAssert(ids == [i1,i2,i3,i4])
        m = moireModel1.readLastCreatedOrEdited()
        XCTAssert(m != nil)
        XCTAssert(m?.id == i4)

        success = moireModel1.delete(moireId: i4)
        assert(success == true)
        ms1 = moireModel1.readAllMoiresSortedByLastCreatedOrModified()
        XCTAssert(ms1.count == 3)
        ids = ms1.compactMap({$0.id})
        XCTAssert(ids == [i1,i3,i2])
        ms2 = moireModel1.readAllMoiresSortedByLastCreated()
        XCTAssert(ms2.count == 3)
        ids = ms2.compactMap({$0.id})
        XCTAssert(ids == [i1,i2,i3])
        m = moireModel1.readLastCreatedOrEdited()
        XCTAssert(m != nil)
        XCTAssert(m?.id == i2)
        
        success = moireModel1.delete(moireId: i1)
        assert(success == true)
        ms1 = moireModel1.readAllMoiresSortedByLastCreatedOrModified()
        XCTAssert(ms1.count == 2)
        ids = ms1.compactMap({$0.id})
        XCTAssert(ids == [i3,i2])
        ms2 = moireModel1.readAllMoiresSortedByLastCreated()
        XCTAssert(ms2.count == 2)
        ids = ms2.compactMap({$0.id})
        XCTAssert(ids == [i2,i3])
        m = moireModel1.readLastCreatedOrEdited()
        XCTAssert(m != nil)
        XCTAssert(m?.id == i2)
        
        success = moireModel1.delete(moireId: i2)
        assert(success == true)
        success = moireModel1.delete(moireId: i3)
        assert(success == true)
        ms1 = moireModel1.readAllMoiresSortedByLastCreatedOrModified()
        XCTAssert(ms1.count == 0)
        ids = ms1.compactMap({$0.id})
        XCTAssert(ids == [])
        ms2 = moireModel1.readAllMoiresSortedByLastCreated()
        XCTAssert(ms2.count == 0)
        ids = ms2.compactMap({$0.id})
        XCTAssert(ids == [])
        m = moireModel1.readLastCreatedOrEdited()
        XCTAssert(m == nil)
    }
}
