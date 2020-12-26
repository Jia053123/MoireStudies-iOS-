//
//  ViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-25.
//

import Foundation
import UIKit

class ViewController: UIViewController, PatternControlTarget {
    private var patterns: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let moireView = self.view as! MoireView
        moireView.displayMoire(patterns: patterns)
    }
    
    func modifyPattern(speed: Double) -> Bool {
        return false
    }
    
    func modifyPattern(direction: Double) -> Bool {
        return false
    }
    
    func modifyPattern(fillRatio: Double) -> Bool {
        return false
    }
    
    func modifyPattern(zoomRatio: Double) -> Bool {
        return false
    }
}

