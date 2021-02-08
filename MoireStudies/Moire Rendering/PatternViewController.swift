//
//  PatternViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-07.
//

import Foundation
import UIKit

protocol PatternViewController : UIViewController {
    func setUpAndRender(pattern: Pattern)
    func updatePattern(newPattern: Pattern)
    func viewControllerLosingFocus() // called when another view controller is pushed atop of the current parent controller
    func takeScreenShot() -> UIImage?
}
