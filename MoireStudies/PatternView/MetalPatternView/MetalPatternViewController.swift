//
//  MetalPatternViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-07.
//

import Foundation
import UIKit

class MetalPatternViewController: UIViewController {
    
    override func loadView() {
        self.view = MetalPatternView()
    }
}

extension MetalPatternViewController: PatternViewController {
    func setUpAndRender(pattern: Pattern) {
        (self.view as! MetalPatternView).setUpAndRender(pattern: pattern)
    }
    
    func updatePattern(newPattern: Pattern) {
        (self.view as! MetalPatternView).updatePattern(newPattern: newPattern)
    }
    
    func viewControllerLosingFocus() {
        (self.view as! MetalPatternView).viewControllerLosingFocus()
    }
    
    func takeScreenShot() -> UIImage? {
        return (self.view as! MetalPatternView).takeScreenShot()
    }
}
