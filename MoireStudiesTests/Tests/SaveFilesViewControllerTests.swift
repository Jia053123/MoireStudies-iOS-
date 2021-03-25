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
        
    }

    override func tearDownWithError() throws {
        
    }
}

class SaveFilesViewControllerTestsCorrupted: XCTestCase {
    
}

class SaveFilesViewControllerTestsReadOnly: XCTestCase {
    
}
