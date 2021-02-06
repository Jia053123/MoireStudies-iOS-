//
//  PatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

protocol PatternView : UIView {
    func setUpAndRender(pattern: Pattern)
    func updatePattern(newPattern: Pattern)
    func viewControllerLosingFocus() // called when another view controller is pushed atop of the current one
    func takeScreenShot() -> UIImage?
}
