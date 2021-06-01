//
//  HighDegCtrlViewControllerBatchEditing.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-05-31.
//

@testable import MoireStudies
import XCTest
import UIKit

class HighDegCtrlViewControllerBatchEditing: XCTestCase {
    var mockPatternManager: MockPatternManagerNormal!
    var highDegCtrlViewControllerBatchEditing: HighDegCtrlViewControllerBatchEditing!

    override func setUpWithError() throws {
        self.mockPatternManager = MockPatternManagerNormal()
        self.highDegCtrlViewControllerBatchEditing = HighDegCtrlViewControllerBatchEditing()
    }

    override func tearDownWithError() throws {
        self.mockPatternManager = nil
        self.highDegCtrlViewControllerBatchEditing = nil
    }
    
    func testAdjustRelativeSpeed_SameAccumulativeEndValueRegardlessOfAdjustmentProcess() {
        // TODO
    }
    
    func testAdjustAllDirection_SameAccumulativeEndValueRegardlessOfAdjustmentProcess() {
        // TODO
    }
    
    func testAdjustAllFillRatio_SameAccumulativeEndValueRegardlessOfAdjustmentProcess() {
        // TODO
    }
    
    func testAdjustAllScale_SameAccumulativeEndValueRegardlessOfAdjustmentProcess() {
        // TODO
    }
}
