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
    var mockMoireViewController: MockMoireViewController!
    var mockControlsViewController: MockControlsViewController!
    var mainViewController: MainViewController!
    
    func prepareMainViewController() {
        self.mainViewController.loadViewIfNeeded()
        self.mainViewController.viewWillAppear(false)
        self.mainViewController.viewDidAppear(false)
    }
    
    func resetAndPopulate(moire: Moire, numOfPatterns: Int) {
        moire.resetData()
        let basePattern = Pattern.init(speed: 10.0, direction: 1.0, blackWidth: 5.0, whiteWidth: 6.0)
        for i in 0..<numOfPatterns {
            let newPattern = Pattern.init(speed: basePattern.speed + CGFloat(i) * 0.01,
                                          direction: basePattern.direction + CGFloat(i) * 0.01,
                                          blackWidth: basePattern.blackWidth + CGFloat(i) * 0.01,
                                          whiteWidth: basePattern.whiteWidth + CGFloat(i) * 0.01)
            assert(BoundsManager.speedRange.contains(newPattern.speed))
            assert(BoundsManager.directionRange.contains(newPattern.direction))
            assert(BoundsManager.blackWidthRange.contains(newPattern.blackWidth))
            assert(BoundsManager.whiteWidthRange.contains(newPattern.whiteWidth))
            moire.patterns.append(newPattern)
        }
    }
}

class MainViewControllerTestsWithNormalModel: MainViewControllerTests {
    var mockMoireModelNormal: MockMoireModelFilesNormal!
    var defaultTestMoire: Moire!
    var defaultTestMoireCopy: Moire!

    override func setUpWithError() throws {
        self.mockMoireModelNormal = MockMoireModelFilesNormal()
        self.mockMoireViewController = MockMoireViewController()
        self.mockControlsViewController = MockControlsViewController()
        self.mainViewController = storyboard.instantiateViewController(identifier: "MainViewController") {coder in
            return MainViewController.init(coder: coder,
                                           mockMoireModel: self.mockMoireModelNormal,
                                           mockMoireViewController: self.mockMoireViewController,
                                           mockControlsViewController: self.mockControlsViewController)
        }
    }
    
    override func tearDownWithError() throws {
        self.mockMoireModelNormal = nil
        self.mockMoireViewController = nil
        self.mockControlsViewController = nil
        self.mainViewController = nil
        self.defaultTestMoire = nil
        self.defaultTestMoireCopy = nil
    }
    
    private func setUpDefaultTestMoire(numOfPatterns: Int) {
        defaultTestMoire = Moire()
        self.resetAndPopulate(moire: defaultTestMoire, numOfPatterns: numOfPatterns)
        defaultTestMoireCopy = defaultTestMoire.copy() as? Moire
        self.mockMoireModelNormal.setStoredMoires(moires: [defaultTestMoire])
    }
    
    private func setUpDefaultTestMoireAndLoad(numOfPatterns: Int) {
        self.setUpDefaultTestMoire(numOfPatterns: numOfPatterns)
        self.prepareMainViewController()
        assert(self.mockMoireViewController.currentPatterns == defaultTestMoireCopy.patterns)
    }
    
    func testSettingUpDependencies() throws {
        let m1 = Moire()
        self.mockMoireModelNormal.setStoredMoires(moires: [m1])
        self.prepareMainViewController()
        
        XCTAssertTrue(self.mockControlsViewController.setUpPerformed)
        XCTAssertTrue(self.mockMoireViewController.setUpPerformed)
    }
}

/// test sending ControlsViewController valid ids and correct settings
extension MainViewControllerTestsWithNormalModel {
    func testSendControlIds_SendIdsThatAreComplete() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 4)
        XCTAssertNotNil(self.mockControlsViewController.ids)
        XCTAssertEqual(self.mockControlsViewController.ids!.count, 4)
    }
    
    func testSendSettings_DefaultSettings_SendSettingsThatIsCompleteAndCorrect() {
        // TODO: update upon adding new entries to the config struct
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 3)
        let frameCount = self.mockControlsViewController.configs?.controlFrames.count
        XCTAssertNotNil(frameCount)
        XCTAssertTrue(frameCount! >= 3)
        
        XCTAssertEqual(self.mainViewController.configurations, self.mockControlsViewController.configs)
        XCTAssertEqual(self.mockControlsViewController.configs, self.mockMoireViewController.configs)
    }
    
    func testSendSettings_CustomSettings_SendSettingsThatIsCompleteAndCorrect() {
        // TODO: update upon adding new entries to the config struct
        var testConfigs = Configurations.init()
        testConfigs.ctrlSchemeSetting = CtrlSchemeSetting.controlScheme1Slider
        let arrOfIndexesToControl: Array<Int> = [1,2]
        let hdcs = HighDegreeControlSettings.init(highDegCtrlSchemeSetting: .basicScheme, indexesOfPatternControlled: arrOfIndexesToControl)
        testConfigs.highDegreeControlSettings = [hdcs]
        self.mainViewController.configurations = testConfigs
        
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 4)
        let frameCount = self.mockControlsViewController.configs?.controlFrames.count
        XCTAssertNotNil(frameCount)
        XCTAssertTrue(frameCount! >= 4)
        
        XCTAssertEqual(self.mainViewController.configurations, self.mockControlsViewController.configs)
        XCTAssertEqual(self.mockControlsViewController.configs?.ctrlSchemeSetting, CtrlSchemeSetting.controlScheme1Slider)
        XCTAssertEqual(self.mockControlsViewController.configs?.highDegreeControlSettings, [hdcs])
        XCTAssertEqual(self.mockControlsViewController.configs?.highDegreeControlCount, 1)
        XCTAssertEqual(self.mockControlsViewController.configs, self.mockMoireViewController.configs)
    }
}

/// test initializing moire from model
extension MainViewControllerTestsWithNormalModel {
    func testLoadMoire_NoInitIdAndModelHasOneEmptyMoire_LoadTheMoire() {
        let m1 = Moire()
        assert(m1.patterns.isEmpty)
        let m1C = m1.copy() as! Moire
        self.mockMoireModelNormal.setStoredMoires(moires: [m1])
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
    }
    
    func testLoadMoire_NoInitIdAndModelHasOneMoire_LoadTheMoire() {
        let m1 = Moire()
        self.resetAndPopulate(moire: m1, numOfPatterns: 4)
        let m1C = m1.copy() as! Moire
        self.mockMoireModelNormal.setStoredMoires(moires: [m1])
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns == m1C.patterns)
    }
    
    func testLoadMoire_NoInitIdAndModelHasOneIllegalMoire_LoadAndCorrectTheMoire() {
        let m1 = Moire()
        self.resetAndPopulate(moire: m1, numOfPatterns: 4)
        m1.patterns[0].speed = BoundsManager.speedRange.upperBound + 9127
        m1.patterns[2].blackWidth = BoundsManager.blackWidthRange.lowerBound - 1
        let m1C = m1.copy() as! Moire
        self.mockMoireModelNormal.setStoredMoires(moires: [m1])
        self.prepareMainViewController()
        let expectedPatterns = Utilities.fitWithinBounds(moire: m1C).patterns
        XCTAssert(self.mockMoireViewController.currentPatterns == expectedPatterns)
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
        
        self.mockMoireModelNormal.setStoredMoires(moires: [])
        _ = self.mockMoireModelNormal.saveOrModify(moire: m1)
        _ = self.mockMoireModelNormal.saveOrModify(moire: m2)
        _ = self.mockMoireModelNormal.saveOrModify(moire: m3)
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns == m3C.patterns)
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited == [m1C, m2C, m3C])
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
        
        self.mockMoireModelNormal.setStoredMoires(moires: [])
        _ = self.mockMoireModelNormal.saveOrModify(moire: m1)
        _ = self.mockMoireModelNormal.saveOrModify(moire: m2)
        _ = self.mockMoireModelNormal.saveOrModify(moire: m3)
        self.mainViewController.moireIdToInit = m2C.id
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns == m2C.patterns)
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited == [m1C, m2C, m3C])
    }
    
    func testLoadMoire_NoInitIdAndModelHasNoMoire_CreateNewAndSave() {
        self.mockMoireModelNormal.setStoredMoires(moires: [])
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns != nil)
        XCTAssert(self.mockMoireViewController.currentPatterns!.count > 0)
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.count == 1)
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first!.patterns == self.mockMoireViewController.currentPatterns!)
    }
    
    func testLoadMoire_WithInitIdAndModelHasNoMoire_CreateNewAndSave() {
        self.mockMoireModelNormal.setStoredMoires(moires: [])
        self.mainViewController.moireIdToInit = "NonexistentMoire"
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns != nil)
        XCTAssert(self.mockMoireViewController.currentPatterns!.count > 0)
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.count == 1)
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first!.patterns == self.mockMoireViewController.currentPatterns!)
    }
}

/// test modifying and saving moires
extension MainViewControllerTestsWithNormalModel {
    func testModifyMoire_ValidIdLegalValuesAndSaved_ReturnTrueAndModifyPatternAndSave() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 4)
        
        let ids = self.mockControlsViewController.ids!
        let p0Id = ids[0]
        let expectedSpeedValue0 = CGFloat(10.153)
        assert(BoundsManager.speedRange.contains(expectedSpeedValue0))
        assert(defaultTestMoireCopy.patterns[0].speed != expectedSpeedValue0)
        XCTAssertTrue(self.mainViewController.modifyPattern(speed: expectedSpeedValue0, callerId: p0Id))
        defaultTestMoireCopy.patterns[0].speed = expectedSpeedValue0
        XCTAssert(self.mockMoireViewController.currentPatterns == defaultTestMoireCopy.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == defaultTestMoireCopy.id}) == defaultTestMoireCopy)
        
        let p1Id = ids[1]
        let expectedDirectionValue1 = CGFloat(1.111)
        assert(BoundsManager.directionRange.contains(expectedDirectionValue1))
        assert(defaultTestMoireCopy.patterns[1].direction != expectedDirectionValue1)
        XCTAssertTrue(self.mainViewController.modifyPattern(direction: 1.0, callerId: p1Id))
        XCTAssertTrue(self.mainViewController.modifyPattern(direction: expectedDirectionValue1, callerId: p1Id))
        defaultTestMoireCopy.patterns[1].direction = expectedDirectionValue1
        XCTAssert(self.mockMoireViewController.currentPatterns == defaultTestMoireCopy.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == defaultTestMoireCopy.id}) == defaultTestMoireCopy)
        
        let p3Id = ids[3]
        let expectedSpeed3 = CGFloat(9.251)
        let expectedDirection3 = CGFloat(1.212)
        let expectedBlackWidth3 = CGFloat(5.953)
        let expectedWhiteWidth3 = CGFloat(6.663)
        assert(BoundsManager.speedRange.contains(expectedSpeed3))
        assert(BoundsManager.directionRange.contains(expectedDirection3))
        assert(BoundsManager.blackWidthRange.contains(expectedBlackWidth3))
        assert(BoundsManager.whiteWidthRange.contains(expectedWhiteWidth3))
        assert(defaultTestMoireCopy.patterns[3].speed != expectedSpeed3)
        assert(defaultTestMoireCopy.patterns[3].direction != expectedDirection3)
        assert(defaultTestMoireCopy.patterns[3].blackWidth != expectedBlackWidth3)
        assert(defaultTestMoireCopy.patterns[3].whiteWidth != expectedWhiteWidth3)
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
        defaultTestMoireCopy.patterns[3].speed = expectedSpeed3
        defaultTestMoireCopy.patterns[3].direction = expectedDirection3
        defaultTestMoireCopy.patterns[3].blackWidth = expectedBlackWidth3
        defaultTestMoireCopy.patterns[3].whiteWidth = expectedWhiteWidth3
        XCTAssert(self.mockMoireViewController.currentPatterns == defaultTestMoireCopy.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == defaultTestMoireCopy.id}) == defaultTestMoireCopy)
    }
    
    func testModifyMoire_CalledWithHighDegId_ValidIdLegalValues_ReturnFalseWithoutModifying() {
        self.setUpDefaultTestMoire(numOfPatterns: 3)
        let hdcs = HighDegreeControlSettings.init(indexesOfPatternControlled: [0,2])
        let config = Configurations.init(highDegreeControlSettings: [hdcs])
        self.mainViewController.configurations = config
        self.prepareMainViewController()
        XCTAssertEqual(self.mockControlsViewController.highDegIds?.count, 1)
        let highDegId = self.mockControlsViewController.highDegIds!.first!
        let newPattern = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 1, seed: 0.288).patterns.first!
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: newPattern.speed, callerId: highDegId))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: newPattern.direction, callerId: highDegId))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: newPattern.blackWidth, callerId: highDegId))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: newPattern.whiteWidth, callerId: highDegId))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns, defaultTestMoireCopy.patterns)
    }
    
    func testModifyMoire_InvalidIdLegalValuesAndSaved_ReturnFalseAndPatternUnchanged() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 3)
        
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
        assert(defaultTestMoireCopy.patterns[2].speed != unexpectedSpeed2)
        assert(defaultTestMoireCopy.patterns[2].direction != unexpectedDirection2)
        assert(defaultTestMoireCopy.patterns[2].blackWidth != unexpectedBlackWidth2)
        assert(defaultTestMoireCopy.patterns[2].whiteWidth != unexpectedWhiteWidth2)
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId2))
        // m1C keeps it's original values
        XCTAssert(self.mockMoireViewController.currentPatterns == defaultTestMoireCopy.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == defaultTestMoireCopy.id}) == defaultTestMoireCopy)
    }
    
    func testModifyMoire_MultiplePatterns_InvalidIdLegalValuesAndSaved_ReturnFalseAndPatternsUnchanged() {
        // Stub
    }
    
    func testModifyMoire_InvalidIdNoPatternLegalValuesAndSaved_ReturnFalseAndPatternUnchanged() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 0)
        
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
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId2))
        // m1C keeps it's original values
        XCTAssert(self.mockMoireViewController.currentPatterns == defaultTestMoireCopy.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == defaultTestMoireCopy.id}) == defaultTestMoireCopy)
    }
    
    func testModifyMoire_ValidIdIlliegalValuesAndSaved_ReturnFalseAndPatternUnchanged() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 4)
        
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
        assert(defaultTestMoireCopy.patterns[2].speed != unexpectedSpeed2)
        assert(defaultTestMoireCopy.patterns[2].direction != unexpectedDirection2)
        assert(defaultTestMoireCopy.patterns[2].blackWidth != unexpectedBlackWidth2)
        assert(defaultTestMoireCopy.patterns[2].whiteWidth != unexpectedWhiteWidth2)
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: p2Id))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: p2Id))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: p2Id))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: p2Id))
        // m1C keeps it's original values
        XCTAssert(self.mockMoireViewController.currentPatterns == defaultTestMoireCopy.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == defaultTestMoireCopy.id}) == defaultTestMoireCopy)
    }
    
    func testModifyMoire_InvalidIdIlliegalValuesAndSaved_ReturnFalseAndPatternUnchanged() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 4)
        
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
        assert(defaultTestMoireCopy.patterns[2].speed != unexpectedSpeed2)
        assert(defaultTestMoireCopy.patterns[2].direction != unexpectedDirection2)
        assert(defaultTestMoireCopy.patterns[2].blackWidth != unexpectedBlackWidth2)
        assert(defaultTestMoireCopy.patterns[2].whiteWidth != unexpectedWhiteWidth2)
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(speed: unexpectedSpeed2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(direction: unexpectedDirection2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(blackWidth: unexpectedBlackWidth2, callerId: invalidId2))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId1))
        XCTAssertFalse(self.mainViewController.modifyPattern(whiteWidth: unexpectedWhiteWidth2, callerId: invalidId2))
        // m1C keeps it's original values
        XCTAssert(self.mockMoireViewController.currentPatterns == defaultTestMoireCopy.patterns)
        XCTAssertTrue(self.mainViewController.saveMoire())
        XCTAssert(self.mockMoireModelNormal.currentMoiresSortedByLastCreatedOrEdited.first(where: {$0.id == defaultTestMoireCopy.id}) == defaultTestMoireCopy)
    }
    
    func testModifyMoire_MultiplePatterns_ValidIdLegalValuesAndSaved_ReturnTrueAndModifyPatternsAndSave() {
        self.setUpDefaultTestMoire(numOfPatterns: 4)
        let hdcs1 = HighDegreeControlSettings.init(indexesOfPatternControlled: Array(0...3))
        let hdcs2 = HighDegreeControlSettings.init(indexesOfPatternControlled: [0,1,3])
        let config = Configurations.init(highDegreeControlSettings: [hdcs1, hdcs2])
        self.mainViewController.configurations = config
        self.prepareMainViewController()
        assert(self.mockControlsViewController.highDegIds?.count == 2)
        assert(self.mockMoireViewController.currentPatterns == defaultTestMoireCopy.patterns)
        // modify all patterns
        let highDegId1 = self.mockControlsViewController.highDegIds!.first!
        let m2 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 4, seed: 1.999)
        assert(defaultTestMoire != m2)
        XCTAssertTrue(self.mainViewController.modifyPatterns(modifiedPatterns: m2.patterns, callerId: highDegId1))
        XCTAssertNotEqual(self.mockMoireViewController.currentPatterns, defaultTestMoire.patterns)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns, m2.patterns)
        // modify some but not all of the patterns
        let highDegId2 = self.mockControlsViewController.highDegIds!.last!
        let m4 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 1.111)
        var expectedPatterns4 = m4.patterns
        expectedPatterns4.insert(self.mockMoireViewController.currentPatterns![2], at: 2)
        XCTAssertTrue(self.mainViewController.modifyPatterns(modifiedPatterns: m4.patterns, callerId: highDegId2))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns, expectedPatterns4)
    }
    
    func testModifyMoire_MultiplePatterns_ValidIdIlliegalValuesAndSaved_ReturnFalseAndPatternsUnchanged() {
        self.setUpDefaultTestMoire(numOfPatterns: 4)
        let hdcs = HighDegreeControlSettings.init(indexesOfPatternControlled: [0,1,3])
        let config = Configurations.init(highDegreeControlSettings: [hdcs])
        self.mainViewController.configurations = config
        self.prepareMainViewController()
        // wrong patterns length
        let highDegId = self.mockControlsViewController.highDegIds!.last!
        let m3 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 4, seed: 0.876)
        let existingPatterns3 = self.mockMoireViewController.currentPatterns
        XCTAssertFalse(self.mainViewController.modifyPatterns(modifiedPatterns: m3.patterns, callerId: highDegId))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns, existingPatterns3)
        // have some valid and invalid values: only the valid ones are applied; return false
        let m5 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 1.926)
        m5.patterns[0].speed = 999999
        assert(!BoundsManager.speedRange.contains(m5.patterns[0].speed))
        m5.patterns[1].direction = -9999999
        assert(!BoundsManager.directionRange.contains(m5.patterns[1].direction))
        m5.patterns[1].whiteWidth = 9999999
        assert(!BoundsManager.whiteWidthRange.contains(m5.patterns[1].whiteWidth))
        m5.patterns[2].blackWidth = -9999999
        assert(!BoundsManager.blackWidthRange.contains(m5.patterns[2].blackWidth))
        var expectedPatterns5 = m5.patterns
        let oldPatterns5 = self.mockMoireViewController.currentPatterns!
        expectedPatterns5[0].speed = oldPatterns5[0].speed
        expectedPatterns5[1].direction = oldPatterns5[1].direction
        expectedPatterns5[1].whiteWidth = oldPatterns5[1].whiteWidth
        expectedPatterns5.insert(oldPatterns5[2], at: 2)
        expectedPatterns5[3].blackWidth = oldPatterns5[3].blackWidth
        XCTAssertFalse(self.mainViewController.modifyPatterns(modifiedPatterns: m5.patterns, callerId: highDegId))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns, expectedPatterns5)
    }
    
    func testModifyMoire_MultiplePatterns_InvalidIdLegalValues_ReturnFalseAndPatternsUnchanged() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 4)
        let m = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 1.004)
        let existingPatterns = self.mockMoireViewController.currentPatterns
        XCTAssertFalse(self.mainViewController.modifyPatterns(modifiedPatterns: m.patterns, callerId: "023"))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns, existingPatterns)
    }
}

/// test modifying patterns' display properties
extension MainViewControllerTestsWithNormalModel {
    func testModifyDisplayProperties_ValidId_CorrectMethodsCalled() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 4)
        
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
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 4)
        
        let invalidId1 = "4"
        let invalidId2 = "3_84365"
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
extension MainViewControllerTestsWithNormalModel {
    func testRetrievePattern_ValidId_ReturnCorrespondingPatternOfTheCurrentMoire() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 3)
        
        let ids = self.mockControlsViewController.ids!
        let p0Id = ids[0]
        let p1Id = ids[1]
        assert(self.mainViewController.modifyPattern(speed: 13.252, callerId: p0Id))
        assert(self.mainViewController.modifyPattern(direction: 1.234, callerId: p1Id))
        defaultTestMoireCopy.patterns[0].speed = 13.252
        defaultTestMoireCopy.patterns[1].direction = 1.234
        XCTAssert(self.mainViewController.getPattern(callerId: p0Id) == defaultTestMoireCopy.patterns[0])
        XCTAssert(self.mainViewController.getPattern(callerId: p1Id) == defaultTestMoireCopy.patterns[1])
    }
    
    func testRetrievePattern_InvalidId_ReturnNil() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 3)
        
        XCTAssertNil(self.mainViewController.getPattern(callerId: "3"))
        XCTAssertNil(self.mainViewController.getPattern(callerId: "-1"))
    }
}

/// test appending patterns in moire
extension MainViewControllerTestsWithNormalModel {
    func testAppendPattern_MoireEmptyPatternWithinLimitNoCaller_ReturnSuccessAndAppend() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 0)
        XCTAssertTrue(self.mainViewController.createPattern(callerId: nil, newPattern: Pattern.debugPattern()))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 1)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], Pattern.debugPattern())
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 1)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], Pattern.debugPattern())
    }
    
    func testAppendPattern_MoireNotEmptyPatternWithinLimitNoCaller_ReturnSuccessAndAppend() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 2)
        XCTAssertTrue(self.mainViewController.createPattern(callerId: nil, newPattern: Pattern.debugPattern()))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 3)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], defaultTestMoireCopy.patterns[0])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[1], defaultTestMoireCopy.patterns[1])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[2], Pattern.debugPattern())
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 3)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], defaultTestMoireCopy.patterns[0])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[1], defaultTestMoireCopy.patterns[1])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[2], Pattern.debugPattern())
    }
    
    func testAppendPattern_MoireNotEmptyPatternWithinLimitHaveCaller_ReturnSuccessAndInsertAfterCallerIndex() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 3)
        let ids = self.mockControlsViewController.ids!
        XCTAssertTrue(self.mainViewController.createPattern(callerId: ids[1], newPattern: Pattern.debugPattern()))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 4)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], defaultTestMoireCopy.patterns[0])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[1], defaultTestMoireCopy.patterns[1])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[2], Pattern.debugPattern())
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[3], defaultTestMoireCopy.patterns[2])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 4)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], defaultTestMoireCopy.patterns[0])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[1], defaultTestMoireCopy.patterns[1])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[2], Pattern.debugPattern())
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[3], defaultTestMoireCopy.patterns[2])
    }
    
    func testAppendPattern_MoireNotEmptyPatternBeyondLimitNoCaller_ReturnFailureMoireStaySame() {
        let upperbound = Constants.Constrains.numOfPatternsPerMoire.upperBound
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: upperbound)
        XCTAssertFalse(self.mainViewController.createPattern(callerId: nil, newPattern: Pattern.debugPattern()))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, upperbound)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, upperbound)
        for i in 0..<5 {
            XCTAssertEqual(self.mockMoireViewController.currentPatterns?[i], defaultTestMoireCopy.patterns[i])
            XCTAssertEqual(self.mockControlsViewController.initPatterns?[i], defaultTestMoireCopy.patterns[i])
        }
    }
    
    func testAppendPattern_MoireNotEmptyPatternBeyondLimitHaveCaller_ReturnFailureMoireStaySame() {
        let upperbound = Constants.Constrains.numOfPatternsPerMoire.upperBound
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: upperbound)
        let ids = self.mockControlsViewController.ids!
        XCTAssertFalse(self.mainViewController.createPattern(callerId: ids[1], newPattern: Pattern.debugPattern()))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, upperbound)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, upperbound)
        for i in 0..<5 {
            XCTAssertEqual(self.mockMoireViewController.currentPatterns?[i], defaultTestMoireCopy.patterns[i])
            XCTAssertEqual(self.mockControlsViewController.initPatterns?[i], defaultTestMoireCopy.patterns[i])
        }
    }
}

/// test deleting patterns in moire
extension MainViewControllerTestsWithNormalModel {
    func testDeletePattern_PatternNotUnderLimitAndValidId_ReturnTrueAndDeletePattern() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 5)
        assert(Constants.Constrains.numOfPatternsPerMoire.contains(5))
        let ids = self.mockControlsViewController.ids!
        
        XCTAssertTrue(self.mainViewController.deletePattern(callerId: ids[1]))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 4)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], defaultTestMoireCopy.patterns[0])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[1], defaultTestMoireCopy.patterns[2])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[2], defaultTestMoireCopy.patterns[3])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[3], defaultTestMoireCopy.patterns[4])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 4)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], defaultTestMoireCopy.patterns[0])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[1], defaultTestMoireCopy.patterns[2])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[2], defaultTestMoireCopy.patterns[3])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[3], defaultTestMoireCopy.patterns[4])
        
        XCTAssertTrue(self.mainViewController.deletePattern(callerId: ids[0]))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 3)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], defaultTestMoireCopy.patterns[2])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[1], defaultTestMoireCopy.patterns[3])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[2], defaultTestMoireCopy.patterns[4])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 3)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], defaultTestMoireCopy.patterns[2])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[1], defaultTestMoireCopy.patterns[3])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[2], defaultTestMoireCopy.patterns[4])
        
        assert(Constants.Constrains.numOfPatternsPerMoire.contains(2))
        XCTAssertTrue(self.mainViewController.deletePattern(callerId: ids[2]))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 2)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], defaultTestMoireCopy.patterns[2])
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[1], defaultTestMoireCopy.patterns[3])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 2)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], defaultTestMoireCopy.patterns[2])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[1], defaultTestMoireCopy.patterns[3])
    }
    
    func testDeletePattern_PatternNotUnderLimitAndInvalidId_ReturnFalseAndPatternStaySame() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 3)
        
        XCTAssertFalse(self.mainViewController.deletePattern(callerId: "4"))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 3)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 3)
        for i in 0..<3 {
            XCTAssertEqual(self.mockMoireViewController.currentPatterns?[i], defaultTestMoireCopy.patterns[i])
            XCTAssertEqual(self.mockControlsViewController.initPatterns?[i], defaultTestMoireCopy.patterns[i])
        }
    }
    
    func testDeletePattern_PatternAtLimitAndValidId_ReturnFalseAndPatternStaySame() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 1)
        assert(!Constants.Constrains.numOfPatternsPerMoire.contains(0))
        
        let ids = self.mockControlsViewController.ids!
        XCTAssertFalse(self.mainViewController.deletePattern(callerId: ids[0]))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 1)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], defaultTestMoireCopy.patterns[0])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 1)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], defaultTestMoireCopy.patterns[0])
    }
    
    func testDeletePattern_PatternAtLimitAndInvalidId_ReturnFalseAndPatternStaySame() {
        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 1)
        assert(!Constants.Constrains.numOfPatternsPerMoire.contains(0))
        
        XCTAssertFalse(self.mainViewController.deletePattern(callerId: "8"))
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?.count, 1)
        XCTAssertEqual(self.mockMoireViewController.currentPatterns?[0], defaultTestMoireCopy.patterns[0])
        XCTAssertEqual(self.mockControlsViewController.initPatterns?.count, 1)
        XCTAssertEqual(self.mockControlsViewController.initPatterns?[0], defaultTestMoireCopy.patterns[0])
    }
}

class MainViewControllerTestsWithCorruptedModel: MainViewControllerTests {
    var mockMoireModelCorrupted: MockMoireModelFilesCorrupted!
    
    override func setUpWithError() throws {
        self.mockMoireModelCorrupted = MockMoireModelFilesCorrupted()
        self.mockMoireViewController = MockMoireViewController()
        self.mockControlsViewController = MockControlsViewController()
        self.mainViewController = storyboard.instantiateViewController(identifier: "MainViewController") {coder in
            return MainViewController.init(coder: coder,
                                           mockMoireModel: self.mockMoireModelCorrupted,
                                           mockMoireViewController: self.mockMoireViewController,
                                           mockControlsViewController: self.mockControlsViewController)
        }
    }
    
    override func tearDownWithError() throws {
        self.mockMoireModelCorrupted = nil
        self.mockMoireViewController = nil
        self.mockControlsViewController = nil
        self.mainViewController = nil
    }
    
    func testLoadMoireWithCorruptedModel_CreateNewAndSave() {
        let m1 = Moire()
        let m2 = Moire()
        let m3 = Moire()
        self.resetAndPopulate(moire: m1, numOfPatterns: 3)
        self.resetAndPopulate(moire: m2, numOfPatterns: 1)
        self.resetAndPopulate(moire: m3, numOfPatterns: 5)
        self.mockMoireModelCorrupted.setMoiresSupposedToBeStored(moires: [m1, m2, m3])
        self.prepareMainViewController()
        XCTAssert(self.mockMoireViewController.currentPatterns != nil)
        XCTAssert(self.mockMoireViewController.currentPatterns!.count > 0)
        XCTAssertEqual(self.mockMoireModelCorrupted.numOfMoires(), 4)
        XCTAssert(self.mockMoireModelCorrupted.moiresSupposedToBeStored.last!.patterns == self.mockMoireViewController.currentPatterns!)
    }
}

class MainViewControllerTestsWithReadonlyModel: MainViewControllerTests {
    var mockMoireModelReadonly: MockMoireModelReadOnly!
    
    override func setUpWithError() throws {
        self.mockMoireModelReadonly = MockMoireModelReadOnly()
        self.mockMoireViewController = MockMoireViewController()
        self.mockControlsViewController = MockControlsViewController()
        self.mainViewController = storyboard.instantiateViewController(identifier: "MainViewController") {coder in
            return MainViewController.init(coder: coder,
                                           mockMoireModel: self.mockMoireModelReadonly,
                                           mockMoireViewController: self.mockMoireViewController,
                                           mockControlsViewController: self.mockControlsViewController)
        }
    }
    
    override func tearDownWithError() throws {
        self.mockMoireModelReadonly = nil
        self.mockMoireViewController = nil
        self.mockControlsViewController = nil
        self.mainViewController = nil
    }
    
    func testModifyMoireWithReadonlyModel_NoRuntimeError() {
        let m = Moire()
        self.resetAndPopulate(moire: m, numOfPatterns: 4)
        let mc = m.copy() as! Moire
        self.mockMoireModelReadonly.setExistingMoires(moires: [m])
        self.prepareMainViewController()
        assert(self.mockMoireViewController.currentPatterns == mc.patterns)
        
        let ids = self.mockControlsViewController.ids!
        let p0Id = ids[0]
        let speedValueToSet = CGFloat(10.153)
        assert(BoundsManager.speedRange.contains(speedValueToSet))
        assert(mc.patterns[0].speed != speedValueToSet)
        XCTAssertTrue(self.mainViewController.modifyPattern(speed: speedValueToSet, callerId: p0Id))
        mc.patterns[0].speed = speedValueToSet
        XCTAssert(self.mockMoireViewController.currentPatterns == mc.patterns)
        assert(!self.mainViewController.saveMoire())
    }
}
