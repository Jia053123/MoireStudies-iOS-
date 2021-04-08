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
    func highlightPattern(callerId: String) -> Bool
    func unhighlightPattern(callerId: String) -> Bool
    func dimPattern(callerId: String) -> Bool
    func undimPattern(callerId: String) -> Bool
    func modifyPattern(speed: CGFloat, callerId: String) -> Bool
    func modifyPattern(direction: CGFloat, callerId: String) -> Bool
    func modifyPattern(blackWidth: CGFloat, callerId: String) -> Bool
    func modifyPattern(whiteWidth: CGFloat, callerId: String) -> Bool
    func getPattern(callerId: String) -> Pattern?
    func hidePattern(callerId: String) -> Bool
    func unhidePattern(callerId: String) -> Bool
    func createPattern(callerId: String?, newPattern: Pattern) -> Bool
    func deletePattern(callerId: String) -> Bool
}
