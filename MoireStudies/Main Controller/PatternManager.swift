//
//  PatternController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

/// these functions return false when the action is illegal, otherwise they return true and the action is performed
protocol PatternManager: UIViewController {
    func modifyPattern(speed: CGFloat, callerId: String) -> Bool
    func modifyPattern(direction: CGFloat, callerId: String) -> Bool
    func modifyPattern(blackWidth: CGFloat, callerId: String) -> Bool
    func modifyPattern(whiteWidth: CGFloat, callerId: String) -> Bool
    /// if array length is wrong, return false; if not all the changes are legal, apply what is legal, and return false
    func modifyPatterns(modifiedPatterns: Array<Pattern>, callerId: String) -> Bool
    
    func retrievePattern(callerId: String) -> Pattern?
    func retrievePatterns(callerId: String) -> Array<Pattern>?
    
    func highlightPattern(callerId: String) -> Bool
    func unhighlightPattern(callerId: String) -> Bool
    func dimPattern(callerId: String) -> Bool
    func undimPattern(callerId: String) -> Bool
    func hidePattern(callerId: String) -> Bool
    func unhidePattern(callerId: String) -> Bool
    
    func createPattern(callerId: String?, newPattern: Pattern) -> Bool
    func deletePattern(callerId: String) -> Bool
    
//    func createHighDegControl(type: HighDegreeControlSettings, patternsToControl: Array<Int>) -> Bool
}
