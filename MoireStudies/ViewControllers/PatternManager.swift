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
    func highlightPattern(caller: CtrlViewTarget) -> Bool
    func unhighlightPattern(caller: CtrlViewTarget) -> Bool
    func modifyPattern(speed: CGFloat, caller: CtrlViewTarget) -> Bool
    func modifyPattern(direction: CGFloat, caller: CtrlViewTarget) -> Bool
    func modifyPattern(blackWidth: CGFloat, caller: CtrlViewTarget) -> Bool
    func modifyPattern(whiteWidth: CGFloat, caller: CtrlViewTarget) -> Bool
    func getPattern(caller: CtrlViewTarget) -> Pattern?
}
