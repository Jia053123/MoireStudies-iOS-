//
//  SaveFilesViewControllerTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-17.
//

@testable import MoireStudies
import XCTest
import UIKit

class SaveFilesViewControllerTests: XCTestCase {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var saveFilesViewController: SaveFilesViewController!
    
    func testLoadCells() -> Array<UICollectionViewCell> { // not sure if this is the correct way to test it...
        var cells: Array<UICollectionViewCell> = []
        let numOfSection = self.saveFilesViewController.numberOfSections(in: self.saveFilesViewController.collectionView)
        for i in 0..<numOfSection {
            let numOfCell = self.saveFilesViewController.collectionView(self.saveFilesViewController.collectionView, numberOfItemsInSection: i)
            for j in 0..<numOfCell {
                let indexPath = IndexPath(row: j, section: i)
                let cell = self.saveFilesViewController.collectionView(self.saveFilesViewController.collectionView, cellForItemAt: indexPath)
                cells.append(cell)
            }
        }
        return cells
    }
    
    func prepareSaveFilesViewController() {
        self.saveFilesViewController.loadViewIfNeeded()
        self.saveFilesViewController.viewWillAppear(false)
        self.saveFilesViewController.viewDidAppear(false)
    }
}

class SaveFilesViewControllerTestsNormal: SaveFilesViewControllerTests {
    var mockMoireModel: MockMoireModelFilesNormal!
    
    override func setUpWithError() throws {
        self.mockMoireModel = MockMoireModelFilesNormal()
        self.saveFilesViewController = storyboard.instantiateViewController(identifier: "SaveFilesViewController") {coder in
            return SaveFilesViewController.init(coder: coder, mockMoireModel: self.mockMoireModel)
        }
    }

    override func tearDownWithError() throws {
        self.mockMoireModel = nil
        self.saveFilesViewController = nil
    }
    
    func testSettingUp_ModelNotEmptyAndIdAvailable_NoRuntimeError() {
        let m1 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 2, seed: 1.513)
        let m1Id = m1.id
        let storedMoires = [m1,
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 2, seed: 1.564),
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 2.998),
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 1, seed: 2.378)]
        self.mockMoireModel.setStoredMoires(moires: storedMoires)
        self.saveFilesViewController.initiallySelectedMoireId = m1Id
        self.prepareSaveFilesViewController()
        _ = self.testLoadCells()
    }
    
    func testSettingUp_ModelNotEmptyButIdNotAvailable_NoRuntimeError() {
        let storedMoires = [TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 2, seed: 1.564),
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 2.998),
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 1, seed: 2.378)]
        self.mockMoireModel.setStoredMoires(moires: storedMoires)
        self.saveFilesViewController.initiallySelectedMoireId = "-9009"
        self.prepareSaveFilesViewController()
        _ = self.testLoadCells()
    }
    
    func testSettingUp_ModelEmptyAndIdNotAvailable_NoRuntimeError() {
        self.prepareSaveFilesViewController()
        self.mockMoireModel.setStoredMoires(moires: [])
        self.saveFilesViewController.initiallySelectedMoireId = nil
        _ = self.testLoadCells()
    }
}

class SaveFilesViewControllerTestsCorrupted: SaveFilesViewControllerTests {
    var mockMoireModel: MockMoireModelFilesCorrupted!
    
    override func setUpWithError() throws {
        self.mockMoireModel = MockMoireModelFilesCorrupted()
        self.saveFilesViewController = storyboard.instantiateViewController(identifier: "SaveFilesViewController") {coder in
            return SaveFilesViewController.init(coder: coder, mockMoireModel: self.mockMoireModel)
        }
    }

    override func tearDownWithError() throws {
        self.mockMoireModel = nil
        self.saveFilesViewController = nil
    }
    
    func testSettingUp_ModelNotEmptyAndIdAvailable_NoRuntimeError() {
        let m1 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 2, seed: 1.513)
        let m1Id = m1.id
        let storedMoires = [m1,
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 2, seed: 1.564),
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 2.998),
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 1, seed: 2.378)]
        self.mockMoireModel.setMoiresSupposedToBeStored(moires: storedMoires)
        self.saveFilesViewController.initiallySelectedMoireId = m1Id
        self.prepareSaveFilesViewController()
        _ = self.testLoadCells()
    }
    
    func testSettingUp_ModelNotEmptyButIdNotAvailable_NoRuntimeError() {
        let storedMoires = [TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 2, seed: 1.564),
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 2.998),
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 1, seed: 2.378)]
        self.mockMoireModel.setMoiresSupposedToBeStored(moires: storedMoires)
        self.saveFilesViewController.initiallySelectedMoireId = "invalid id"
        self.prepareSaveFilesViewController()
        _ = self.testLoadCells()
    }
    
    func testSettingUp_ModelEmptyAndIdNotAvailable_NoRuntimeError() {
        self.prepareSaveFilesViewController()
        self.mockMoireModel.setMoiresSupposedToBeStored(moires: [])
        self.saveFilesViewController.initiallySelectedMoireId = nil
        _ = self.testLoadCells()
    }
}

class SaveFilesViewControllerTestsReadOnly: SaveFilesViewControllerTests {
    var mockMoireModel: MockMoireModelReadOnly!
    
    override func setUpWithError() throws {
        self.mockMoireModel = MockMoireModelReadOnly()
        self.saveFilesViewController = storyboard.instantiateViewController(identifier: "SaveFilesViewController") {coder in
            return SaveFilesViewController.init(coder: coder, mockMoireModel: self.mockMoireModel)
        }
    }

    override func tearDownWithError() throws {
        self.mockMoireModel = nil
        self.saveFilesViewController = nil
    }
    
    func testSettingUp_ModelNotEmptyAndIdAvailable_NoRuntimeError() {
        let m1 = TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 2, seed: 1.513)
        let m1Id = m1.id
        let storedMoires = [m1,
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 2, seed: 1.564),
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 2.998),
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 1, seed: 2.378)]
        self.mockMoireModel.setExistingMoires(moires: storedMoires)
        self.saveFilesViewController.initiallySelectedMoireId = m1Id
        self.prepareSaveFilesViewController()
        _ = self.testLoadCells()
    }
    
    func testSettingUp_ModelNotEmptyButIdNotAvailable_NoRuntimeError() {
        let storedMoires = [TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 2, seed: 1.564),
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 3, seed: 2.998),
                            TestUtilities.createValidPseudoRandomMoire(numOfPatterns: 1, seed: 2.378)]
        self.mockMoireModel.setExistingMoires(moires: storedMoires)
        self.saveFilesViewController.initiallySelectedMoireId = "invalid id"
        self.prepareSaveFilesViewController()
        _ = self.testLoadCells()
    }
    
    func testSettingUp_ModelEmptyAndIdNotAvailable_NoRuntimeError() {
        self.prepareSaveFilesViewController()
        self.mockMoireModel.setExistingMoires(moires: [])
        self.saveFilesViewController.initiallySelectedMoireId = nil
        _ = self.testLoadCells()
    }
}
