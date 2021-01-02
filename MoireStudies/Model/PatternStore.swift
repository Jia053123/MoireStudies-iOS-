//
//  PatternController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

protocol PatternStore: UIViewController {
    func modifyPattern(speed: CGFloat, caller: CtrlViewControllerSch1) -> Bool
    func modifyPattern(direction: CGFloat, caller: CtrlViewControllerSch1) -> Bool
    func modifyPattern(fillRatio: CGFloat, caller: CtrlViewControllerSch1) -> Bool
    func modifyPattern(zoomRatio: CGFloat, caller: CtrlViewControllerSch1) -> Bool
}
