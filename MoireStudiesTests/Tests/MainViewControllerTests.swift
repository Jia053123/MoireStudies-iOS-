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
    
    func testSetUpDependencies() throws {
        let m1 = Moire()
        self.mockMoireModel.setMockMoires(moires: [m1])
        self.prepareMainViewController()
        
        XCTAssertTrue(self.mockControlsViewController.setUpPerformed)
        XCTAssertTrue(self.mockMoireViewController.setUpPerformed)
    }
}

/// test loading the initial moire from model
extension MainViewControllerTests {
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
        
        self.mockMoireModel.setMockMoires(moires: [m1, m2, m3])
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
        
        self.mockMoireModel.setMockMoires(moires: [m1, m2, m3])
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
