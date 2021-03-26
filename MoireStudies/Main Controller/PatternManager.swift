//
//  PatternController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

protocol PatternManager: UIViewController {
    // these functions return false when the action is illegal, otherwise they return true and the action is performed
    func highlightPattern(callerId: Int) -> Bool
    func unhighlightPattern(callerId: Int) -> Bool
    func dimPattern(callerId: Int) -> Bool
    func undimPattern(callerId: Int) -> Bool
    func modifyPattern(speed: CGFloat, callerId: Int) -> Bool
    func modifyPattern(direction: CGFloat, callerId: Int) -> Bool
    func modifyPattern(blackWidth: CGFloat, callerId: Int) -> Bool
    func modifyPattern(whiteWidth: CGFloat, callerId: Int) -> Bool
    func getPattern(callerId: Int) -> Pattern?
    func hidePattern(callerId: Int) -> Bool
    func unhidePattern(callerId: Int) -> Bool
    func createPattern(callerId: Int?, newPattern: Pattern) -> Bool
    func deletePattern(callerId: Int) -> Bool
}
