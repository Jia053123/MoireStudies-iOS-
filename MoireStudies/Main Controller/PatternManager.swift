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
    /// if cannot apply all the changes, apply what is legal, and return false
    func modifyPatterns(modifiedPatterns: Array<Pattern>, callerId: String) -> Bool
    
    func getPattern(callerId: String) -> Pattern?
    func getPatterns(callerId: String) -> Array<Pattern>?
    
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
