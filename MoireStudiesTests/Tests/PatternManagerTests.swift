//
//  PatternManagerTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-04-18.
//

@testable import MoireStudies
import XCTest
import UIKit

class PatternManagerTestsWithNormalModel: XCTestCase {
    var patternManager: PatternManager!
    var mockMoireModelNormal: MockMoireModelFilesNormal!
    var m1: Moire!
    var m1C: Moire!
    
    override func setUpWithError() throws {
        self.patternManager = PatternManager()
        self.mockMoireModelNormal = MockMoireModelNormal()
    }
    
    override func tearDownWithError() throws {
        self.patternManager = nil
        self.mockMoireModelNormal = nil
    }
}

/// test modifying and saving moires
extension PatternManagerTestsWithNormalModel {
    func testModifyMoire_ValidIdLegalValuesAndSaved_ReturnTrueAndModifyPatternAndSave() {
        self.setUpOneMoireAndLoad(numOfPatterns: 4)
        
        let ids = self.mockControlsViewController.ids!
        let p0Id = ids[0]
        let expectedSpeedValue0 = CGFloat(10.153)
        assert(BoundsManager.speedRange.contains(expectedSpeedValue0))
        assert(m1C.patterns[0].speed != expectedSpeedValue0)
        XCTAssertTrue(self.patternManager.modifyPattern(speed: expectedSpeedValue0, callerId: p0Id))
        m1C.patterns[0].speed = expectedSpeedValue0
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.patternManager.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == m1C.id}) == m1C)
        
        let p1Id = ids[1]
        let expectedDirectionValue1 = CGFloat(1.111)
        assert(BoundsManager.directionRange.contains(expectedDirectionValue1))
        assert(m1C.patterns[1].direction != expectedDirectionValue1)
        XCTAssertTrue(self.patternManager.modifyPattern(direction: 1.0, callerId: p1Id))
        XCTAssertTrue(self.patternManager.modifyPattern(direction: expectedDirectionValue1, callerId: p1Id))
        m1C.patterns[1].direction = expectedDirectionValue1
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.patternManager.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == m1C.id}) == m1C)
        
        let p3Id = ids[3]
        let expectedSpeed3 = CGFloat(9.251)
        let expectedDirection3 = CGFloat(1.212)
        let expectedBlackWidth3 = CGFloat(5.953)
        let expectedWhiteWidth3 = CGFloat(6.663)
        assert(BoundsManager.speedRange.contains(expectedSpeed3))
        assert(BoundsManager.directionRange.contains(expectedDirection3))
        assert(BoundsManager.blackWidthRange.contains(expectedBlackWidth3))
        assert(BoundsManager.whiteWidthRange.contains(expectedWhiteWidth3))
        assert(m1C.patterns[3].speed != expectedSpeed3)
        assert(m1C.patterns[3].direction != expectedDirection3)
        assert(m1C.patterns[3].blackWidth != expectedBlackWidth3)
        assert(m1C.patterns[3].whiteWidth != expectedWhiteWidth3)
        XCTAssertTrue(self.patternManager.modifyPattern(direction: 1.0, callerId: p3Id))
        XCTAssertTrue(self.patternManager.modifyPattern(speed: 14.0, callerId: p3Id))
        XCTAssertTrue(self.patternManager.modifyPattern(whiteWidth: 3.0, callerId: p3Id))
        XCTAssertTrue(self.patternManager.modifyPattern(direction: 2.0, callerId: p3Id))
        XCTAssertTrue(self.patternManager.modifyPattern(direction: expectedDirection3, callerId: p3Id))
        XCTAssertTrue(self.patternManager.modifyPattern(blackWidth: 7.0, callerId: p3Id))
        XCTAssertTrue(self.patternManager.modifyPattern(whiteWidth: expectedWhiteWidth3, callerId: p3Id))
        XCTAssertTrue(self.patternManager.modifyPattern(speed: 15.0, callerId: p3Id))
        XCTAssertTrue(self.patternManager.modifyPattern(speed: expectedSpeed3, callerId: p3Id))
        XCTAssertTrue(self.patternManager.modifyPattern(blackWidth: expectedBlackWidth3, callerId: p3Id))
        m1C.patterns[3].speed = expectedSpeed3
        m1C.patterns[3].direction = expectedDirection3
        m1C.patterns[3].blackWidth = expectedBlackWidth3
        m1C.patterns[3].whiteWidth = expectedWhiteWidth3
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.patternManager.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == m1C.id}) == m1C)
    }
    
    func testModifyMoire_MultiplePatterns_ValidIdLegalValuesAndSaved_ReturnTrueAndModifyPatternsAndSave() {
        self.setUpOneMoireAndLoadWithOneHighDegCtrl(numOfPatterns: 4)
//        let highDegId = self.mockControlsViewController.highDegIds!.last
    }
    
    func testModifyMoire_InvalidIdLegalValuesAndSaved_ReturnFalseAndPatternUnchanged() {
        self.setUpOneMoireAndLoad(numOfPatterns: 3)
        
        let invalidId1 = "3" // an invalid id that looks just like a valid one except it's not registered within the matcher
        let invalidId2 = "-14365a76"
        let unexpectedSpeed2 = CGFloat(9.251)
        let unexpectedDirection2 = CGFloat(1.212)
        let unexpectedBlackWidth2 = CGFloat(5.953)
        let unexpectedWhiteWidth2 = CGFloat(6.663)
        assert(BoundsManager.speedRange.contains(unexpectedSpeed2))
        assert(BoundsManager.directionRange.contains(unexpectedDirection2))
        assert(BoundsManager.blackWidthRange.contains(unexpectedBlackWidth2))
        assert(BoundsManager.whiteWidthRange.contains(unexpectedWhiteWidth2))
        assert(m1C.patterns[2].speed != unexpectedSpeed2)
        assert(m1C.patterns[2].direction != unexpectedDirection2)
        assert(m1C.patterns[2].blackWidth != unexpectedBlackWidth2)
        assert(m1C.patterns[2].whiteWidth != unexpectedWhiteWidth2)
        XCTAssertFalse(self.patternManager.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId1))
        XCTAssertFalse(self.patternManager.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId2))
        XCTAssertFalse(self.patternManager.modifyPattern(direction: unexpectedDirection2, callerId: invalidId1))
        XCTAssertFalse(self.patternManager.modifyPattern(direction: unexpectedDirection2, callerId: invalidId2))
        XCTAssertFalse(self.patternManager.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId1))
        XCTAssertFalse(self.patternManager.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId2))
        XCTAssertFalse(self.patternManager.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId1))
        XCTAssertFalse(self.patternManager.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId2))
        // m1C keeps it's original values
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.patternManager.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == m1C.id}) == m1C)
    }
    
    func testModifyMoire_MultiplePatterns_InvalidIdLegalValuesAndSaved_ReturnFalseAndPatternsUnchanged() {
        // Stub
    }
    
    func testModifyMoire_InvalidIdNoPatternLegalValuesAndSaved_ReturnFalseAndPatternUnchanged() {
        self.setUpOneMoireAndLoad(numOfPatterns: 0)
        
        let invalidId1 = "0"
        let invalidId2 = "-143b5276"
        let unexpectedSpeed2 = CGFloat(9.251)
        let unexpectedDirection2 = CGFloat(1.212)
        let unexpectedBlackWidth2 = CGFloat(5.953)
        let unexpectedWhiteWidth2 = CGFloat(6.663)
        assert(BoundsManager.speedRange.contains(unexpectedSpeed2))
        assert(BoundsManager.directionRange.contains(unexpectedDirection2))
        assert(BoundsManager.blackWidthRange.contains(unexpectedBlackWidth2))
        assert(BoundsManager.whiteWidthRange.contains(unexpectedWhiteWidth2))
        XCTAssertFalse(self.patternManager.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId1))
        XCTAssertFalse(self.patternManager.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId2))
        XCTAssertFalse(self.patternManager.modifyPattern(direction: unexpectedDirection2, callerId: invalidId1))
        XCTAssertFalse(self.patternManager.modifyPattern(direction: unexpectedDirection2, callerId: invalidId2))
        XCTAssertFalse(self.patternManager.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId1))
        XCTAssertFalse(self.patternManager.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId2))
        XCTAssertFalse(self.patternManager.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId1))
        XCTAssertFalse(self.patternManager.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId2))
        // m1C keeps it's original values
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.patternManager.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == m1C.id}) == m1C)
    }
    
    func testModifyMoire_MultiplePatterns_InvalidIdNotEnoughPatternLegalValuesAndSaved_ReturnFalseAndPatternsUnchanged() {
        // Stub
    }
    
    func testModifyMoire_ValidIdIlliegalValuesAndSaved_ReturnFalseAndPatternUnchanged() {
        self.setUpOneMoireAndLoad(numOfPatterns: 4)
        
        let ids = self.mockControlsViewController.ids!
        let p2Id = ids[2]
        let unexpectedSpeed2 = CGFloat(100000)
        let unexpectedDirection2 = CGFloat(100000)
        let unexpectedBlackWidth2 = CGFloat(100000)
        let unexpectedWhiteWidth2 = CGFloat(100000)
        assert(!BoundsManager.speedRange.contains(unexpectedSpeed2))
        assert(!BoundsManager.directionRange.contains(unexpectedDirection2))
        assert(!BoundsManager.blackWidthRange.contains(unexpectedBlackWidth2))
        assert(!BoundsManager.whiteWidthRange.contains(unexpectedWhiteWidth2))
        assert(m1C.patterns[2].speed != unexpectedSpeed2)
        assert(m1C.patterns[2].direction != unexpectedDirection2)
        assert(m1C.patterns[2].blackWidth != unexpectedBlackWidth2)
        assert(m1C.patterns[2].whiteWidth != unexpectedWhiteWidth2)
        XCTAssertFalse(self.patternManager.modifyPattern(speed: unexpectedSpeed2, callerId: p2Id))
        XCTAssertFalse(self.patternManager.modifyPattern(direction: unexpectedDirection2, callerId: p2Id))
        XCTAssertFalse(self.patternManager.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: p2Id))
        XCTAssertFalse(self.patternManager.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: p2Id))
        // m1C keeps it's original values
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.patternManager.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == m1C.id}) == m1C)
    }
    
    func testModifyMoire_MultiplePatterns_ValidIdIlliegalValuesAndSaved_ReturnFalseAndPatternsUnchanged() {
        //Stub
    }
    
    func testModifyMoire_InvalidIdIlliegalValuesAndSaved_ReturnFalseAndPatternUnchanged() {
        self.setUpOneMoireAndLoad(numOfPatterns: 4)
        
        let invalidId1 = "4" // an invalid id that looks just like a valid one except it's not registered within the matcher
        let invalidId2 = "91939096"
        let unexpectedSpeed2 = CGFloat(100000)
        let unexpectedDirection2 = CGFloat(100000)
        let unexpectedBlackWidth2 = CGFloat(100000)
        let unexpectedWhiteWidth2 = CGFloat(100000)
        assert(!BoundsManager.speedRange.contains(unexpectedSpeed2))
        assert(!BoundsManager.directionRange.contains(unexpectedDirection2))
        assert(!BoundsManager.blackWidthRange.contains(unexpectedBlackWidth2))
        assert(!BoundsManager.whiteWidthRange.contains(unexpectedWhiteWidth2))
        assert(m1C.patterns[2].speed != unexpectedSpeed2)
        assert(m1C.patterns[2].direction != unexpectedDirection2)
        assert(m1C.patterns[2].blackWidth != unexpectedBlackWidth2)
        assert(m1C.patterns[2].whiteWidth != unexpectedWhiteWidth2)
        XCTAssertFalse(self.patternManager.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId1))
        XCTAssertFalse(self.patternManager.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId2))
        XCTAssertFalse(self.patternManager.modifyPattern(direction: unexpectedDirection2, callerId: invalidId1))
        XCTAssertFalse(self.patternManager.modifyPattern(direction: unexpectedDirection2, callerId: invalidId2))
        XCTAssertFalse(self.patternManager.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId1))
        XCTAssertFalse(self.patternManager.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId2))
        XCTAssertFalse(self.patternManager.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId1))
        XCTAssertFalse(self.patternManager.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId2))
        // m1C keeps it's original values
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.patternManager.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == m1C.id}) == m1C)
    }
    
    func testModifyMoire_MultiplePatterns_InvalidIdIlliegalValuesAndSaved_ReturnFalseAndPatternsUnchanged() {
        // Stub
    }
}

/// test modifying patterns' display properties
extension PatternManagerTestsWithNormalModel {
    func testModifyDisplayProperties_ValidId_CorrectMethodsCalled() {
        self.setUpOneMoireAndLoad(numOfPatterns: 4)
        
        let ids = self.mockControlsViewController.ids!
        let p0Id = ids[0]
        let p1Id = ids[1]
        let p2Id = ids[2]
        let p3Id = ids[3]
        XCTAssertTrue(self.patternManager.highlightPattern(callerId: p0Id))
        XCTAssertTrue(self.patternManager.highlightPattern(callerId: p1Id))
        XCTAssertTrue(self.patternManager.unhighlightPattern(callerId: p1Id))
        XCTAssertTrue(self.patternManager.dimPattern(callerId: p2Id))
        XCTAssertTrue(self.patternManager.undimPattern(callerId: p2Id))
        XCTAssertTrue(self.patternManager.dimPattern(callerId: p3Id))
        XCTAssertTrue(self.patternManager.hidePattern(callerId: p0Id))
        XCTAssertTrue(self.patternManager.hidePattern(callerId: p3Id))
        XCTAssertTrue(self.patternManager.unhidePattern(callerId: p0Id))
        XCTAssert(self.mockMoireViewController.highlightedPatternIndexes == [0, 1])
        XCTAssert(self.mockMoireViewController.unhighlightedPatternIndexes == [1])
        XCTAssert(self.mockMoireViewController.dimmedPatternIndexes == [2, 3])
        XCTAssert(self.mockMoireViewController.patternsUndimmed == true)
        XCTAssert(self.mockMoireViewController.hiddenPatternIndexes == [0, 3])
        XCTAssert(self.mockMoireViewController.unhiddenPatternIndexes == [0])
    }
    
    func testModifyDisplayProperties_InvalidId_ReturnFalseAndMethodsNotCalled() {
        self.setUpOneMoireAndLoad(numOfPatterns: 4)
        
        let invalidId1 = "4"
        let invalidId2 = "3_84365"
        XCTAssertFalse(self.patternManager.highlightPattern(callerId: invalidId1))
        XCTAssertFalse(self.patternManager.highlightPattern(callerId: invalidId2))
        XCTAssertFalse(self.patternManager.unhighlightPattern(callerId: invalidId1))
        XCTAssertFalse(self.patternManager.dimPattern(callerId: invalidId2))
        XCTAssertFalse(self.patternManager.undimPattern(callerId: invalidId1))
        XCTAssertFalse(self.patternManager.dimPattern(callerId: invalidId1))
        XCTAssertFalse(self.patternManager.hidePattern(callerId: invalidId2))
        XCTAssertFalse(self.patternManager.hidePattern(callerId: invalidId1))
        XCTAssertFalse(self.patternManager.unhidePattern(callerId: invalidId2))
        XCTAssert(self.mockMoireViewController.highlightedPatternIndexes == [])
        XCTAssert(self.mockMoireViewController.unhighlightedPatternIndexes == [])
        XCTAssert(self.mockMoireViewController.dimmedPatternIndexes == [])
        XCTAssert(self.mockMoireViewController.patternsUndimmed == false)
        XCTAssert(self.mockMoireViewController.hiddenPatternIndexes == [])
        XCTAssert(self.mockMoireViewController.unhiddenPatternIndexes == [])
    }
}

/// test sending pattern data back to the controls
extension PatternManagerTestsWithNormalModel {
    func testRetrievePattern_ValidId_ReturnCorrespondingPatternOfTheCurrentMoire() {
        self.setUpOneMoireAndLoad(numOfPatterns: 3)
        
        let ids = self.mockControlsViewController.ids!
        let p0Id = ids[0]
        let p1Id = ids[1]
        assert(self.patternManager.modifyPattern(speed: 13.252, callerId: p0Id))
        assert(self.patternManager.modifyPattern(direction: 1.234, callerId: p1Id))
        m1C.patterns[0].speed = 13.252
        m1C.patterns[1].direction = 1.234
        XCTAssert(self.patternManager.getPattern(callerId: p0Id) == m1C.patterns[0])
        XCTAssert(self.patternManager.getPattern(callerId: p1Id) == m1C.patterns[1])
    }
    
    func testRetrievePattern_InvalidId_ReturnNil() {
        self.setUpOneMoireAndLoad(numOfPatterns: 3)
        
        XCTAssertNil(self.patternManager.getPattern(callerId: "3"))
        XCTAssertNil(self.patternManager.getPattern(callerId: "-1"))
    }
}

/// test appending patterns in moire
extension PatternManagerTestsWithNormalModel {
    func testAppendPattern_MoireEmptyPatternWithinLimitNoCaller_ReturnSuccessAndAppend() {
        self.setUpOneMoireAndLoad(numOfPatterns: 0)
        XCTAssertTrue(self.patternManager.createPattern(callerId: nil, newPattern: Pattern.debugPattern()))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 1)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], Pattern.debugPattern())
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 1)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], Pattern.debugPattern())
    }
    
    func testAppendPattern_MoireNotEmptyPatternWithinLimitNoCaller_ReturnSuccessAndAppend() {
        self.setUpOneMoireAndLoad(numOfPatterns: 2)
        XCTAssertTrue(self.patternManager.createPattern(callerId: nil, newPattern: Pattern.debugPattern()))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 3)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], m1C.patterns[0])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[1], m1C.patterns[1])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[2], Pattern.debugPattern())
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 3)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], m1C.patterns[0])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[1], m1C.patterns[1])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[2], Pattern.debugPattern())
    }
    
    func testAppendPattern_MoireNotEmptyPatternWithinLimitHaveCaller_ReturnSuccessAndInsertAfterCallerIndex() {
        self.setUpOneMoireAndLoad(numOfPatterns: 3)
        let ids = self.mockControlsViewController.ids!
        XCTAssertTrue(self.patternManager.createPattern(callerId: ids[1], newPattern: Pattern.debugPattern()))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 4)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], m1C.patterns[0])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[1], m1C.patterns[1])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[2], Pattern.debugPattern())
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[3], m1C.patterns[2])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 4)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], m1C.patterns[0])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[1], m1C.patterns[1])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[2], Pattern.debugPattern())
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[3], m1C.patterns[2])
    }
    
    func testAppendPattern_MoireNotEmptyPatternBeyondLimitNoCaller_ReturnFailureMoireStaySame() {
        let upperbound = Constants.Constrains.numOfPatternsPerMoire.upperBound
        self.setUpOneMoireAndLoad(numOfPatterns: upperbound)
        XCTAssertFalse(self.patternManager.createPattern(callerId: nil, newPattern: Pattern.debugPattern()))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, upperbound)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, upperbound)
        for i in 0..<5 {
            XCTAssertEqual(self.mockMoireViewController.currentPatterns?[i], m1C.patterns[i])
            XCTAssertEqual(self.mockControlsViewController.initPatterns?[i], m1C.patterns[i])
        }
    }
    
    func testAppendPattern_MoireNotEmptyPatternBeyondLimitHaveCaller_ReturnFailureMoireStaySame() {
        let upperbound = Constants.Constrains.numOfPatternsPerMoire.upperBound
        self.setUpOneMoireAndLoad(numOfPatterns: upperbound)
        let ids = self.mockControlsViewController.ids!
        XCTAssertFalse(self.patternManager.createPattern(callerId: ids[1], newPattern: Pattern.debugPattern()))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, upperbound)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, upperbound)
        for i in 0..<5 {
            XCTAssertEqual(self.mockMoireViewController.currentPatterns?[i], m1C.patterns[i])
            XCTAssertEqual(self.mockControlsViewController.initPatterns?[i], m1C.patterns[i])
        }
    }
}

/// test deleting patterns in moire
extension PatternManagerTestsWithNormalModel {
    func testDeletePattern_PatternNotUnderLimitAndValidId_ReturnTrueAndDeletePattern() {
        self.setUpOneMoireAndLoad(numOfPatterns: 5)
        assert(Constants.Constrains.numOfPatternsPerMoire.contains(5))
        let ids = self.mockControlsViewController.ids!
        
        XCTAssertTrue(self.patternManager.deletePattern(callerId: ids[1]))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 4)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], m1C.patterns[0])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[1], m1C.patterns[2])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[2], m1C.patterns[3])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[3], m1C.patterns[4])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 4)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], m1C.patterns[0])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[1], m1C.patterns[2])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[2], m1C.patterns[3])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[3], m1C.patterns[4])
        
        XCTAssertTrue(self.patternManager.deletePattern(callerId: ids[0]))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 3)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], m1C.patterns[2])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[1], m1C.patterns[3])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[2], m1C.patterns[4])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 3)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], m1C.patterns[2])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[1], m1C.patterns[3])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[2], m1C.patterns[4])
        
        assert(Constants.Constrains.numOfPatternsPerMoire.contains(2))
        XCTAssertTrue(self.patternManager.deletePattern(callerId: ids[2]))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 2)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], m1C.patterns[2])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[1], m1C.patterns[3])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 2)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], m1C.patterns[2])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[1], m1C.patterns[3])
    }
    
    func testDeletePattern_PatternNotUnderLimitAndInvalidId_ReturnFalseAndPatternStaySame() {
        self.setUpOneMoireAndLoad(numOfPatterns: 3)
        
        XCTAssertFalse(self.patternManager.deletePattern(callerId: "4"))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 3)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 3)
        for i in 0..<3 {
            XCTAssertEqual(self.mockMoireViewController.currentPatterns?[i], m1C.patterns[i])
            XCTAssertEqual(self.mockControlsViewController.initPatterns?[i], m1C.patterns[i])
        }
    }
    
    func testDeletePattern_PatternAtLimitAndValidId_ReturnFalseAndPatternStaySame() {
        self.setUpOneMoireAndLoad(numOfPatterns: 1)
        assert(!Constants.Constrains.numOfPatternsPerMoire.contains(0))
        
        let ids = self.mockControlsViewController.ids!
        XCTAssertFalse(self.patternManager.deletePattern(callerId: ids[0]))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 1)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], m1C.patterns[0])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 1)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], m1C.patterns[0])
    }
    
    func testDeletePattern_PatternAtLimitAndInvalidId_ReturnFalseAndPatternStaySame() {
        self.setUpOneMoireAndLoad(numOfPatterns: 1)
        assert(!Constants.Constrains.numOfPatternsPerMoire.contains(0))
        
        XCTAssertFalse(self.patternManager.deletePattern(callerId: "8"))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 1)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], m1C.patterns[0])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 1)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], m1C.patterns[0])
    }
}

class PatternManagerTestsWithReadonlyModel: XCTestCase {
    var mockMoireModelReadonly: MockMoireModelReadOnly!
    
    override func setUpWithError() throws {
        self.mockMoireModelReadonly = MockMoireModelReadOnly()
        self.mockMoireViewController = MockMoireViewController()
        self.mockControlsViewController = MockControlsViewController()
        self.patternManager = storyboard.instantiateViewController(identifier: "patternManager") {coder in
            return patternManager.init(coder: coder,
                                           mockMoireModel: self.mockMoireModelReadonly,
                                           mockMoireViewController: self.mockMoireViewController,
                                           mockControlsViewController: self.mockControlsViewController)
        }
    }
    
    override func tearDownWithError() throws {
        self.mockMoireModelReadonly = nil
        self.mockMoireViewController = nil
        self.mockControlsViewController = nil
        self.patternManager = nil
    }
    
    func testModifyMoireWithReadonlyModel_NoRuntimeError() {
        let m = Moire()
        self.resetAndPopulate(moire: m, numOfPatterns: 4)
        let mc = m.copy() as! Moire
        self.mockMoireModelReadonly.setExistingMoires(moires: [m])
        self.preparepatternManager()
        assert(self.mockMoireViewController.currentPatterns == mc.patterns)
        
        let ids = self.mockControlsViewController.ids!
        let p0Id = ids[0]
        let speedValueToSet = CGFloat(10.153)
        assert(BoundsManager.speedRange.contains(speedValueToSet))
        assert(mc.patterns[0].speed != speedValueToSet)
        XCTAssertTrue(self.patternManager.modifyPattern(speed: speedValueToSet, callerId: p0Id))
        mc.patterns[0].speed = speedValueToSet
        XCTAssert(self.mockMoireViewController.currentPatterns == mc.patterns)
        assert(!self.patternManager.saveMoire())
    }
}
