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
    func highlightPattern(caller: CtrlViewController) -> Bool
    func unhighlightPattern(caller: CtrlViewController) -> Bool
    func modifyPattern(speed: CGFloat, caller: CtrlViewController) -> Bool
    func modifyPattern(direction: CGFloat, caller: CtrlViewController) -> Bool
    func modifyPattern(blackWidth: CGFloat, caller: CtrlViewController) -> Bool
    func modifyPattern(whiteWidth: CGFloat, caller: CtrlViewController) -> Bool
    func getPattern(caller: CtrlViewController) -> Pattern?
}
