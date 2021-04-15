//
//  ControlsViewControllerTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-04-12.
//

@testable import MoireStudies
import XCTest
import UIKit

class ControlsViewControllerTests: XCTestCase {
    var controlsViewController: ControlsViewController!

    override func setUpWithError() throws {
        self.controlsViewController = ControlsViewController.init()
    }

    override func tearDownWithError() throws {
        self.controlsViewController = nil
    }
}
