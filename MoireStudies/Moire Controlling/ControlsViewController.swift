//
//  ControlsViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-08.
//

import Foundation
import UIKit

class ControlsViewController: UIViewController {
    override func loadView() {
        self.view = ControlsView()
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
    }
    
    func setup(patterns: Array<Pattern>, settings: InitSettings, matcher: CtrlAndPatternMatcher, delegate: PatternManager) {
        (self.view as! ControlsView).setup(patterns: patterns, settings: settings, matcher: matcher, delegate: delegate)
    }
    
    func reset(patterns: Array<Pattern>, settings: InitSettings, matcher: CtrlAndPatternMatcher, delegate: PatternManager) {
        (self.view as! ControlsView).reset(patterns: patterns, settings: settings, matcher: matcher, delegate: delegate)
    }
}
