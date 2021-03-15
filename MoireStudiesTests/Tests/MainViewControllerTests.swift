//
//  MainViewControllerTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-05.
//

@testable import MoireStudies
import XCTest
import UIKit

class MainViewControllerTests: XCTestCase {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var mockMoireModel: MockMoireModel!
    var mockMoireViewController: MockMoireViewController!
    var mockControlsViewController: MockControlsViewController!
    var mainViewController: MainViewController!
    var m1: Moire!
    var m1C: Moire!

    override func setUpWithError() throws {
        self.mockMoireModel = MockMoireModel()
        self.mockMoireViewController = MockMoireViewController()
        self.mockControlsViewController = MockControlsViewController()
        self.mainViewController = storyboard.instantiateViewController(identifier: "MainViewController") {coder in
            return MainViewController.init(coder: coder,
                                           mockMoireModel: self.mockMoireModel,
                                           mockMoireViewController: self.mockMoireViewController,
                                           mockControlsViewController: self.mockControlsViewController)
        }
    }
    
    override func tearDownWithError() throws {
        self.mockMoireModel = nil
        self.mockMoireViewController = nil
        self.mockControlsViewController = nil
        self.mainViewController = nil
        self.m1 = nil
        self.m1C = nil
    }
    
    private func prepareMainViewController() {
        self.mainViewController.loadViewIfNeeded()
        self.mainViewController.viewWillAppear(false)
        self.mainViewController.viewDidAppear(false)
    }
    
    private func resetAndPopulate(moire: Moire, numOfPatterns: Int) {
        moire.resetData()
        for _ in 0..<numOfPatterns {
            moire.patterns.append(Pattern.randomPattern())
        }
    }
    
    private func setUpOneMoireAndLoad(numOfPatterns: Int) {
        m1 = Moire()
        self.resetAndPopulate(moire: m1, numOfPatterns: numOfPatterns)
        m1C = m1.copy() as? Moire
        self.mockMoireModel.setMockMoires(moires: [m1])
        self.prepareMainViewController()
        assert(self.mockMoireViewController.currentPatterns == m1C.patterns)
    }
    
    func testSettingUpDependencies() throws {
        let m1 = Moire()
        self.mockMoireModel.setMockMoires(moires: [m1])
        self.prepareMainViewController()
        
        XCTAssertTrue(self.mockControlsViewController.setUpPerformed)
        XCTAssertTrue(self.mockMoireViewController.setUpPerformed)
    }
}

/// test sending  ControlsViewController valid ids corresponding to the current moire
extension MainViewControllerTests {
    func testSendControlIds_SendIdsThatAreComplete() {
        self.setUpOneMoireAndLoad(numOfPatterns: 4)
        XCTAssertNotNil(self.mockControlsViewController.ids)
        XCTAssertEqual(self.mockControlsViewController.ids!.count, 4)
    }
}

/// test loading the moire to edit from model
extension MainViewControllerTests {
    func testLoadMoire_NoInitIdAndModelHasOneEmptyMoire_LoadTheMoire() {
        let m1 = Moire()
        assert(m1.patterns.isEmpty)
        let m1C = m1.copy() as! Moire
        self.mockMoireModel.setMockMoires(moires: [m1])
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
    }
    
    func testLoadMoire_NoInitIdAndModelHasOneMoire_LoadTheMoire() {
        let m1 = Moire()
        self.resetAndPopulate(moire: m1, numOfPatterns: 4)
        let m1C = m1.copy() as! Moire
        self.mockMoireModel.setMockMoires(moires: [m1])
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
    }
    
    func testLoadMoire_NoInitIdAndModelHasMultipleMoires_LoadTheLatestOne() {
        let m1 = Moire()
        let m2 = Moire()
        let m3 = Moire()
        self.resetAndPopulate(moire: m1, numOfPatterns: 3)
        self.resetAndPopulate(moire: m2, numOfPatterns: 1)
        self.resetAndPopulate(moire: m3, numOfPatterns: 5)
        let m1C = m1.copy() as! Moire
        let m2C = m2.copy() as! Moire
        let m3C = m3.copy() as! Moire
        
        self.mockMoireModel.setMockMoires(moires: [])
        _ = self.mockMoireModel.saveOrModify(moire: m1)
        _ = self.mockMoireModel.saveOrModify(moire: m2)
        _ = self.mockMoireModel.saveOrModify(moire: m3)
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns == m3C.patterns)
        XCTAssert(self.mockMoireModel.currentMoires == [m1C, m2C, m3C])
    }
    
    func testLoadMoire_WithInitIdAndModelHasTheOneWithId_LoadTheOneWithId() {
        let m1 = Moire()
        let m2 = Moire()
        let m3 = Moire()
        self.resetAndPopulate(moire: m1, numOfPatterns: 3)
        self.resetAndPopulate(moire: m2, numOfPatterns: 1)
        self.resetAndPopulate(moire: m3, numOfPatterns: 5)
        let m1C = m1.copy() as! Moire
        let m2C = m2.copy() as! Moire
        let m3C = m3.copy() as! Moire
        
        self.mockMoireModel.setMockMoires(moires: [])
        _ = self.mockMoireModel.saveOrModify(moire: m1)
        _ = self.mockMoireModel.saveOrModify(moire: m2)
        _ = self.mockMoireModel.saveOrModify(moire: m3)
        self.mainViewController.moireIdToInit = m2C.id
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns == m2C.patterns)
        XCTAssert(self.mockMoireModel.currentMoires == [m1C, m2C, m3C])
    }
    
    func testLoadMoire_NoInitIdAndModelHasNoMoire_CreateNewAndSave() {
        self.mockMoireModel.setMockMoires(moires: [])
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns != nil)
        XCTAssert(self.mockMoireViewController.currentPatterns!.count > 0)
        XCTAssert(self.mockMoireModel.currentMoires.count == 1)
        XCTAssert(self.mockMoireModel.currentMoires.first!.patterns == self.mockMoireViewController.currentPatterns!)
    }
    
    func testLoadMoire_WithInitIdAndModelHasNoMoire_CreateNewAndSave() {
        self.mockMoireModel.setMockMoires(moires: [])
        self.mainViewController.moireIdToInit = "NonexistentMoire"
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns != nil)
        XCTAssert(self.mockMoireViewController.currentPatterns!.count > 0)
        XCTAssert(self.mockMoireModel.currentMoires.count == 1)
        XCTAssert(self.mockMoireModel.currentMoires.first!.patterns == self.mockMoireViewController.currentPatterns!)
    }
}

/// test modifying and saving moires
extension MainViewControllerTests {
    func testModifyMoire_ValidIdLegalValuesAndSaved_ReturnTrueAndModifyPatternAndSave() {
        self.setUpOneMoireAndLoad(numOfPatterns: 4)
        
        let ids = self.mockControlsViewController.ids!
        let p0Id = ids[0]
        let expectedSpeedValue0 = CGFloat(10.153)
        assert(Constants.Bounds.speedRange.contains(expectedSpeedValue0))
        assert(m1C.patterns[0].speed != expectedSpeedValue0)
        XCTAssertTrue(self.mainViewController.modifyPattern(speed: expectedSpeedValue0, callerId: p0Id))
        m1C.patterns[0].speed = expectedSpeedValue0
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModel.currentMoires.first(where: {$0.id == m1C.id}) == m1C)
        
        let p1Id = ids[1]
        let expectedDirectionValue1 = CGFloat(1.111)
        assert(Constants.Bounds.directionRange.contains(expectedDirectionValue1))
        assert(m1C.patterns[1].direction != expectedDirectionValue1)
        XCTAssertTrue(self.mainViewController.modifyPattern(direction: 1.0, callerId: p1Id))
        XCTAssertTrue(self.mainViewController.modifyPattern(direction: expectedDirectionValue1, callerId: p1Id))
        m1C.patterns[1].direction = expectedDirectionValue1
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModel.currentMoires.first(where: {$0.id == m1C.id}) == m1C)
        
        let p3Id = ids[3]
        let expectedSpeed3 = CGFloat(9.251)
        let expectedDirection3 = CGFloat(1.212)
        let expectedBlackWidth3 = CGFloat(5.953)
        let expectedWhiteWidth3 = CGFloat(6.663)
        assert(Constants.Bounds.speedRange.contains(expectedSpeed3))
        assert(Constants.Bounds.directionRange.contains(expectedDirection3))
        assert(Constants.Bounds.blackWidthRange.contains(expectedBlackWidth3))
        assert(Constants.Bounds.whiteWidthRange.contains(expectedWhiteWidth3))
        assert(m1C.patterns[3].speed != expectedSpeed3)
        assert(m1C.patterns[3].direction != expectedDirection3)
        assert(m1C.patterns[3].blackWidth != expectedBlackWidth3)
        assert(m1C.patterns[3].whiteWidth != expectedWhiteWidth3)
        XCTAssertTrue(self.mainViewController.modifyPattern(direction: 1.0, callerId: p3Id))
        XCTAssertTrue(self.mainViewController.modifyPattern(speed: 14.0, callerId: p3Id))
        XCTAssertTrue(self.mainViewController.modifyPattern(whiteWidth: 3.0, callerId: p3Id))
        XCTAssertTrue(self.mainViewController.modifyPattern(direction: 2.0, callerId: p3Id))
        XCTAssertTrue(self.mainViewController.modifyPattern(direction: expectedDirection3, callerId: p3Id))
        XCTAssertTrue(self.mainViewController.modifyPattern(blackWidth: 7.0, callerId: p3Id))
        XCTAssertTrue(self.mainViewController.modifyPattern(whiteWidth: expectedWhiteWidth3, callerId: p3Id))
        XCTAssertTrue(self.mainViewController.modifyPattern(speed: 15.0, callerId: p3Id))
        XCTAssertTrue(self.mainViewController.modifyPattern(speed: expectedSpeed3, callerId: p3Id))
        XCTAssertTrue(self.mainViewController.modifyPattern(blackWidth: expectedBlackWidth3, callerId: p3Id))
        m1C.patterns[3].speed = expectedSpeed3
        m1C.patterns[3].direction = expectedDirection3
        m1C.patterns[3].blackWidth = expectedBlackWidth3
        m1C.patterns[3].whiteWidth = expectedWhiteWidth3
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModel.currentMoires.first(where: {$0.id == m1C.id}) == m1C)
    }
    
    func testModifyMoire_InvalidIdLegalValuesAndSaved_ReturnFalseAndPatternUnchanged() {
        self.setUpOneMoireAndLoad(numOfPatterns: 3)
        
        let invalidId1 = 3 // an invalid id that looks just like a valid one except it's not registered within the matcher
        let invalidId2 = -14365276
        let unexpectedSpeed2 = CGFloat(9.251)
        let unexpectedDirection2 = CGFloat(1.212)
        let unexpectedBlackWidth2 = CGFloat(5.953)
        let unexpectedWhiteWidth2 = CGFloat(6.663)
        assert(Constants.Bounds.speedRange.contains(unexpectedSpeed2))
        assert(Constants.Bounds.directionRange.contains(unexpectedDirection2))
        assert(Constants.Bounds.blackWidthRange.contains(unexpectedBlackWidth2))
        assert(Constants.Bounds.whiteWidthRange.contains(unexpectedWhiteWidth2))
        assert(m1C.patterns[2].speed != unexpectedSpeed2)
        assert(m1C.patterns[2].direction != unexpectedDirection2)
        assert(m1C.patterns[2].blackWidth != unexpectedBlackWidth2)
        assert(m1C.patterns[2].whiteWidth != unexpectedWhiteWidth2)
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId2))
        // m1C keeps it's original values
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModel.currentMoires.first(where: {$0.id == m1C.id}) == m1C)
    }
    
    func testModifyMoire_InvalidIdNoPatternLegalValuesAndSaved_ReturnFalseAndPatternUnchanged() {
        self.setUpOneMoireAndLoad(numOfPatterns: 0)
        
        let invalidId1 = 0
        let invalidId2 = -14365276
        let unexpectedSpeed2 = CGFloat(9.251)
        let unexpectedDirection2 = CGFloat(1.212)
        let unexpectedBlackWidth2 = CGFloat(5.953)
        let unexpectedWhiteWidth2 = CGFloat(6.663)
        assert(Constants.Bounds.speedRange.contains(unexpectedSpeed2))
        assert(Constants.Bounds.directionRange.contains(unexpectedDirection2))
        assert(Constants.Bounds.blackWidthRange.contains(unexpectedBlackWidth2))
        assert(Constants.Bounds.whiteWidthRange.contains(unexpectedWhiteWidth2))
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId2))
        // m1C keeps it's original values
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModel.currentMoires.first(where: {$0.id == m1C.id}) == m1C)
    }
    
    func testModifyMoire_ValidIdIlliegalValuesAndSaved_ReturnFalseAndPatternUnchanged() {
        self.setUpOneMoireAndLoad(numOfPatterns: 4)
        
        let ids = self.mockControlsViewController.ids!
        let p2Id = ids[2]
        let unexpectedSpeed2 = CGFloat(100000)
        let unexpectedDirection2 = CGFloat(100000)
        let unexpectedBlackWidth2 = CGFloat(100000)
        let unexpectedWhiteWidth2 = CGFloat(100000)
        assert(!Constants.Bounds.speedRange.contains(unexpectedSpeed2))
        assert(!Constants.Bounds.directionRange.contains(unexpectedDirection2))
        assert(!Constants.Bounds.blackWidthRange.contains(unexpectedBlackWidth2))
        assert(!Constants.Bounds.whiteWidthRange.contains(unexpectedWhiteWidth2))
        assert(m1C.patterns[2].speed != unexpectedSpeed2)
        assert(m1C.patterns[2].direction != unexpectedDirection2)
        assert(m1C.patterns[2].blackWidth != unexpectedBlackWidth2)
        assert(m1C.patterns[2].whiteWidth != unexpectedWhiteWidth2)
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: p2Id))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: p2Id))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: p2Id))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: p2Id))
        // m1C keeps it's original values
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModel.currentMoires.first(where: {$0.id == m1C.id}) == m1C)
    }
    
    func testModifyMoire_InvalidIdIlliegalValuesAndSaved_ReturnFalseAndPatternUnchanged() {
        self.setUpOneMoireAndLoad(numOfPatterns: 4)
        
        let invalidId1 = 4 // an invalid id that looks just like a valid one except it's not registered within the matcher
        let invalidId2 = 9195939096
        let unexpectedSpeed2 = CGFloat(100000)
        let unexpectedDirection2 = CGFloat(100000)
        let unexpectedBlackWidth2 = CGFloat(100000)
        let unexpectedWhiteWidth2 = CGFloat(100000)
        assert(!Constants.Bounds.speedRange.contains(unexpectedSpeed2))
        assert(!Constants.Bounds.directionRange.contains(unexpectedDirection2))
        assert(!Constants.Bounds.blackWidthRange.contains(unexpectedBlackWidth2))
        assert(!Constants.Bounds.whiteWidthRange.contains(unexpectedWhiteWidth2))
        assert(m1C.patterns[2].speed != unexpectedSpeed2)
        assert(m1C.patterns[2].direction != unexpectedDirection2)
        assert(m1C.patterns[2].blackWidth != unexpectedBlackWidth2)
        assert(m1C.patterns[2].whiteWidth != unexpectedWhiteWidth2)
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId2))
        // m1C keeps it's original values
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModel.currentMoires.first(where: {$0.id == m1C.id}) == m1C)
    }
}

/// test modifying patterns' display properties
extension MainViewControllerTests {
    func testModifyDisplayProperties_ValidId_CorrectMethodsCalled() {
        self.setUpOneMoireAndLoad(numOfPatterns: 4)
        
        let ids = self.mockControlsViewController.ids!
        let p0Id = ids[0]
        let p1Id = ids[1]
        let p2Id = ids[2]
        let p3Id = ids[3]
        XCTAssertTrue(self.mainViewController.highlightPattern(callerId: p0Id))
        XCTAssertTrue(self.mainViewController.highlightPattern(callerId: p1Id))
        XCTAssertTrue(self.mainViewController.unhighlightPattern(callerId: p1Id))
        XCTAssertTrue(self.mainViewController.dimPattern(callerId: p2Id))
        XCTAssertTrue(self.mainViewController.undimPattern(callerId: p2Id))
        XCTAssertTrue(self.mainViewController.dimPattern(callerId: p3Id))
        XCTAssertTrue(self.mainViewController.hidePattern(callerId: p0Id))
        XCTAssertTrue(self.mainViewController.hidePattern(callerId: p3Id))
        XCTAssertTrue(self.mainViewController.unhidePattern(callerId: p0Id))
        XCTAssert(self.mockMoireViewController.highlightedPatternIndexes == [0, 1])
        XCTAssert(self.mockMoireViewController.unhighlightedPatternIndexes == [1])
        XCTAssert(self.mockMoireViewController.dimmedPatternIndexes == [2, 3])
        XCTAssert(self.mockMoireViewController.patternsUndimmed == true)
        XCTAssert(self.mockMoireViewController.hiddenPatternIndexes == [0, 3])
        XCTAssert(self.mockMoireViewController.unhiddenPatternIndexes == [0])
    }
    
    func testModifyDisplayProperties_InvalidId_ReturnFalseAndMethodsNotCalled() {
        self.setUpOneMoireAndLoad(numOfPatterns: 4)
        
        let invalidId1 = 4
        let invalidId2 = 84365
        XCTAssertFalse(self.mainViewController.highlightPattern(callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.highlightPattern(callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.unhighlightPattern(callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.dimPattern(callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.undimPattern(callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.dimPattern(callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.hidePattern(callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.hidePattern(callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.unhidePattern(callerId: invalidId2))
        XCTAssert(self.mockMoireViewController.highlightedPatternIndexes == [])
        XCTAssert(self.mockMoireViewController.unhighlightedPatternIndexes == [])
        XCTAssert(self.mockMoireViewController.dimmedPatternIndexes == [])
        XCTAssert(self.mockMoireViewController.patternsUndimmed == false)
        XCTAssert(self.mockMoireViewController.hiddenPatternIndexes == [])
        XCTAssert(self.mockMoireViewController.unhiddenPatternIndexes == [])
    }
}

/// test sending pattern data back to the controls
extension MainViewControllerTests {
    func testRetrievePattern_ValidId_ReturnCorrespondingPatternOfTheCurrentMoire() {
        self.setUpOneMoireAndLoad(numOfPatterns: 3)
        
        let ids = self.mockControlsViewController.ids!
        let p0Id = ids[0]
        let p1Id = ids[1]
        assert(self.mainViewController.modifyPattern(speed: 13.252, callerId: p0Id))
        assert(self.mainViewController.modifyPattern(direction: 1.234, callerId: p1Id))
        m1C.patterns[0].speed = 13.252
        m1C.patterns[1].direction = 1.234
        XCTAssert(self.mainViewController.getPattern(callerId: p0Id) == m1C.patterns[0])
        XCTAssert(self.mainViewController.getPattern(callerId: p1Id) == m1C.patterns[1])
    }
    
    func testRetrievePattern_InvalidId_ReturnNil() {
        self.setUpOneMoireAndLoad(numOfPatterns: 3)
        
        XCTAssertNil(self.mainViewController.getPattern(callerId: 3))
        XCTAssertNil(self.mainViewController.getPattern(callerId: -1))
    }
}

/// test appending patterns in moire
extension MainViewControllerTests {
}

/// test deleting patterns in moire
extension MainViewControllerTests {
}
