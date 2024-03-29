//
//  MockHighDegCtrlViewController.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-05-07.
//

import Foundation
import UIKit

/// not in the unit test target so that it can be assigned as an option in Constants while avoiding circular referencing
class MockHighDegCtrlViewController: UIViewController, AbstractHighDegCtrlViewController {
    static let supportedNumOfPatterns: ClosedRange<Int> = 2...4
    var id: String!
    var patternsDelegate: PatternManager!
    
    required init(id: String, frame: CGRect, patterns: Array<Pattern?>) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func matchControlsWithModel(patterns: Array<Pattern?>) {
        // TODO: stub
    }
    
    
}
