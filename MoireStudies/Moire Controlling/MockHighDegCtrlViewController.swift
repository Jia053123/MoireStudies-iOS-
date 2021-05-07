//
//  MockHighDegCtrlViewController.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-05-07.
//

import Foundation
import UIKit

class MockHighDegCtrlViewController: UIViewController, HighDegCtrlViewController {
    static let supportedNumOfPatterns: ClosedRange<Int> = 2...4
    var id: String!
    var delegate: PatternManager!
    
    required init(id: String, frame: CGRect, patterns: Array<Pattern?>) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func matchControlsWithModel(patterns: Array<Pattern?>) {
    }
    
    
}
