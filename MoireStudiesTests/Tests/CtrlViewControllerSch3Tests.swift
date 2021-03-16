//
//  BasicCtrlViewControllerTests.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-05.
//

@testable import MoireStudies
import XCTest
import UIKit

class CtrlViewControllerSch3TestsLegal: XCTestCase {
    let id = 1111
    var ctrlViewController: CtrlViewControllerSch3?
    var mockPatternManagerLegal: MockPatternManagerLegal?
    let testPattern1 = Pattern.init(speed: 25.0, direction: 1.78, blackWidth: 5.34, whiteWidth: 7.22)
    var testPattern1Copy: Pattern?
    
    override func setUpWithError() throws {
        assert(Utilities.isWithinBounds(pattern: testPattern1))
        self.testPattern1Copy = self.testPattern1
        self.ctrlViewController = CtrlViewControllerSch3.init(id: self.id, frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), pattern: self.testPattern1)
        self.mockPatternManagerLegal = MockPatternManagerLegal()
        self.mockPatternManagerLegal!.setCurrentPatternControlled(initPattern: self.testPattern1)
        self.ctrlViewController?.delegate = self.mockPatternManagerLegal
    }

    override func tearDownWithError() throws {
        self.ctrlViewController = nil
        self.mockPatternManagerLegal = nil
        self.testPattern1Copy = nil
    }
}

class CtrlViewControllerSch3TestsIlligal: XCTestCase {
    var ctrlViewController: CtrlViewControllerSch3?
    var mockPatternManagerIllegal: MockPatternManagerIllegal?
}
