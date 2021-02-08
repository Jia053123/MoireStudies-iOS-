//
//  MainViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-07.
//

import Foundation
import UIKit

class MoireViewController: UIViewController {
    override func loadView() {
        let mv = MainView()
        mv.initHelper()
        self.view = mv
    }
    
    func setUp(patterns: Array<Pattern>) {
        (self.view as! MainView).setUp(patterns: patterns)
    }
    
    func numOfPatternViews() -> Int {
        return (self.view as! MainView).numOfPatternViews()
    }
    
    func resetMoireView(patterns: Array<Pattern>) {
        (self.view as! MainView).resetMoireView(patterns: patterns)
    }
    
    func setUpMasks() {
        (self.view as! MainView).setUpMasks()
    }
    
    func highlightPatternView(patternViewIndex: Int) {
        (self.view as! MainView).highlightPatternView(patternViewIndex: patternViewIndex)
    }
    
    func unhighlightPatternView(patternViewIndex: Int) {
        (self.view as! MainView).unhighlightPatternView(patternViewIndex: patternViewIndex)
    }
    
    func modifyPatternView(patternViewIndex: Int, newPattern: Pattern) {
        (self.view as! MainView).modifyPatternView(patternViewIndex: patternViewIndex, newPattern: newPattern)
    }
    
    func viewControllerLosingFocus() {
        (self.view as! MainView).viewControllerLosingFocus()
    }
    
    func takeMoireScreenshot() -> UIImage? {
        return (self.view as! MainView).takeMoireScreenshot()
    }
}
