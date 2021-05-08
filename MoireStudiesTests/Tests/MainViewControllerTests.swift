//
//  MainViewControllerTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-05-08.
//

@testable import MoireStudies
import XCTest
import UIKit

class MainViewControllerTests: XCTestCase {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var mockMoireModelNormal: MockMoireModelFilesNormal!
    var mockMoireViewController: MockMoireViewController!
    var mockControlsViewController: MockControlsViewController!
    var mainViewController: MainViewController!
    
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
//        self.defaultTestMoire = nil
//        self.defaultTestMoireCopy = nil
    }
    
    func prepareMainViewController() {
        self.mainViewController.loadViewIfNeeded()
        self.mainViewController.viewWillAppear(false)
        self.mainViewController.viewDidAppear(false)
    }
    
    func testEnteringSelectionMode_CalledCorrespondingMethodInControlsViewController() {
//        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 4)
        self.prepareMainViewController()
        self.mainViewController.newHighDegCtrlButtonPressed(NSObject())
        XCTAssertTrue(self.mockControlsViewController.enteredSelectionMode)
        XCTAssertFalse(self.mockControlsViewController.exitedSelectionMode)
    }

    func testExitingSelectionMode_CalledCorrespondingMethodInControlsViewController() {
//        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 4)
        self.prepareMainViewController()
        self.mainViewController.cancelButtonPressed(NSObject())
        XCTAssertTrue(self.mockControlsViewController.exitedSelectionMode)
        self.mainViewController.newHighDegCtrlButtonPressed(NSObject())
        self.mainViewController.cancelButtonPressed(NSObject())
        XCTAssertTrue(self.mockControlsViewController.exitedSelectionMode)
    }

    func testConfirmInSelectionMode_ExitSelectionMode() {
//        self.setUpDefaultTestMoireAndLoad(numOfPatterns: 4)
        self.prepareMainViewController()
        self.mainViewController.newHighDegCtrlButtonPressed(NSObject())
        assert(self.mockControlsViewController.enteredSelectionMode)
        self.mainViewController.confirmButtonPressed(NSObject())
        XCTAssertTrue(self.mockControlsViewController.exitedSelectionMode)
    }
}
