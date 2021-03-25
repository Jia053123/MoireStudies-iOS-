//
//  SaveFilesViewControllerTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-17.
//

@testable import MoireStudies
import XCTest
import UIKit

class SaveFilesViewControllerTestsNormal: XCTestCase {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var saveFilesViewController: SaveFilesViewController!
    var mockMoireModel: MockMoireModelFilesNormal!
    var initialMoireId: String?
    
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
    
    private func prepareSaveFilesViewController() {
        self.saveFilesViewController.loadViewIfNeeded()
        self.saveFilesViewController.viewWillAppear(false)
        self.saveFilesViewController.viewDidAppear(false)
    }
    
    func testSettingUp_ModelNotEmptyAndIdAvailable_NoRuntimeError() {
        
    }
    
    func testSettingUp_ModelNotEmptyButIdNotAvailable_NoRuntimeError() {
        
    }
    
    func testSettingUp_ModelEmptyAndIdNotAvailable_NoRuntimeError() {
        self.prepareSaveFilesViewController()
    }
}

class SaveFilesViewControllerTestsCorrupted: XCTestCase {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var saveFilesViewController: SaveFilesViewController!
    var mockMoireModel: MockMoireModelFilesCorrupted!
    var initialMoireId: String?
    
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
    
    private func prepareSaveFilesViewController() {
        self.saveFilesViewController.loadViewIfNeeded()
        self.saveFilesViewController.viewWillAppear(false)
        self.saveFilesViewController.viewDidAppear(false)
    }
    
    private func createPseudoRandomMoire(numOfPatterns: Int, seed: CGFloat) -> Moire {
        let newMoire = Moire()
        newMoire.resetData()
        let adjustment = seed.truncatingRemainder(dividingBy: 1.0)
        let basePattern = Pattern.init(speed: 10.0+adjustment, direction: 1.0+adjustment, blackWidth: 5.0+adjustment, whiteWidth: 6.0+adjustment)
        for i in 0..<numOfPatterns {
            let newPattern = Pattern.init(speed: basePattern.speed + CGFloat(i) * 0.01,
                                          direction: basePattern.direction + CGFloat(i) * 0.01,
                                          blackWidth: basePattern.blackWidth + CGFloat(i) * 0.01,
                                          whiteWidth: basePattern.whiteWidth + CGFloat(i) * 0.01)
            assert(Constants.Bounds.speedRange.contains(newPattern.speed))
            assert(Constants.Bounds.directionRange.contains(newPattern.direction))
            assert(Constants.Bounds.blackWidthRange.contains(newPattern.blackWidth))
            assert(Constants.Bounds.whiteWidthRange.contains(newPattern.whiteWidth))
            newMoire.patterns.append(newPattern)
        }
        return newMoire
    }
    
    private func testLoadCells() -> Array<UICollectionViewCell> { // not sure if this is the correct way to test it...
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
    
    func testSettingUp_ModelNotEmptyAndIdAvailable_NoRuntimeError() {
        let m1 = self.createPseudoRandomMoire(numOfPatterns: 2, seed: 1.513)
        let m1Id = m1.id
        let storedMoires = [m1,
                            self.createPseudoRandomMoire(numOfPatterns: 2, seed: 1.564),
                            self.createPseudoRandomMoire(numOfPatterns: 3, seed: 2.998),
                            self.createPseudoRandomMoire(numOfPatterns: 1, seed: 2.378)]
        self.mockMoireModel.setMoiresSupposedToBeStored(moires: storedMoires)
        self.saveFilesViewController.initiallySelectedMoireId = m1Id
        self.prepareSaveFilesViewController()
        _ = self.testLoadCells()
    }
    
    func testSettingUp_ModelNotEmptyButIdNotAvailable_NoRuntimeError() {
        let storedMoires = [self.createPseudoRandomMoire(numOfPatterns: 2, seed: 1.564),
                            self.createPseudoRandomMoire(numOfPatterns: 3, seed: 2.998),
                            self.createPseudoRandomMoire(numOfPatterns: 1, seed: 2.378)]
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

class SaveFilesViewControllerTestsReadOnly: XCTestCase {
    func testSettingUp_ModelNotEmptyAndIdAvailable_NoRuntimeError() {
        
    }
    
    func testSettingUp_ModelNotEmptyButIdNotAvailable_NoRuntimeError() {
        
    }
    
    func testSettingUp_ModelEmptyAndIdNotAvailable_NoRuntimeError() {
        
    }
}
