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
    var copyOfInitPattern: Pattern?
    
    override func setUpWithError() throws {
        self.ctrlViewController = CtrlViewControllerSch3.init(id: self.id, frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), pattern: Pattern.defaultPattern())
        self.mockPatternManagerLegal = MockPatternManagerLegal()
        self.mockPatternManagerLegal!.setMockPatternControlledByCaller(initPattern: Pattern.defaultPattern())
        self.ctrlViewController?.delegate = self.mockPatternManagerLegal
        self.copyOfInitPattern = Pattern.defaultPattern()
    }

    override func tearDownWithError() throws {
        self.ctrlViewController = nil
        self.mockPatternManagerLegal = nil
        self.copyOfInitPattern = nil
    }
}

class CtrlViewControllerSch3TestsIlligal: XCTestCase {
    var ctrlViewController: CtrlViewControllerSch3?
    var mockPatternManagerIllegal: MockPatternManagerIllegal?
}
