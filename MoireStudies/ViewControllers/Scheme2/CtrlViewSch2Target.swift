//
//  PatternCtrlTargetSch2.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

protocol CtrlViewSch2Target: CtrlViewTarget {
    // these functions return false when the action is illegal, otherwise they return true and the action is performed
    func modifyPattern(speed: CGFloat) -> Bool
    func modifyPattern(direction: CGFloat) -> Bool
    func modifyPattern(blackWidth: CGFloat) -> Bool
    func modifyPattern(whiteWidth: CGFloat) -> Bool
}
