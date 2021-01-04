//
//  PatternController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

protocol PatternStore: UIViewController {
    func modifyPattern(speed: CGFloat, caller: CtrlViewController) -> Bool
    func modifyPattern(direction: CGFloat, caller: CtrlViewController) -> Bool
    func modifyPattern(fillRatio: CGFloat, caller: CtrlViewController) -> Bool
    func modifyPattern(zoomRatio: CGFloat, caller: CtrlViewController) -> Bool
}
