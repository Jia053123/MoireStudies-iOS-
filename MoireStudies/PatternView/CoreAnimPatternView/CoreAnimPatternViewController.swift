//
//  CoreAnimPatternViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-08.
//

import Foundation
import UIKit

class CoreAnimPatternViewController: UIViewController {
    
    override func loadView() {
        self.view = CoreAnimPatternView()
    }
}

extension CoreAnimPatternViewController: PatternViewController {
    func setUpAndRender(pattern: Pattern) {
        (self.view as! CoreAnimPatternView).setUpAndRender(pattern: pattern)
    }
    
    func updatePattern(newPattern: Pattern) {
        (self.view as! CoreAnimPatternView).updatePattern(newPattern: newPattern)
    }
    
    func viewControllerLosingFocus() {
        (self.view as! CoreAnimPatternView).viewControllerLosingFocus()
    }
    
    func takeScreenShot() -> UIImage? {
        return (self.view as! CoreAnimPatternView).takeScreenShot()
    }
}
