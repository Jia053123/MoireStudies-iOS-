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
    
    func testSetUpDependencies() throws {
        let m1 = Moire()
        self.mockMoireModel.setMockMoires(moires: [m1])
        self.prepareMainViewController()
        
        XCTAssertTrue(self.mockControlsViewController.setUpPerformed)
        XCTAssertTrue(self.mockMoireViewController.setUpPerformed)
    }
}


