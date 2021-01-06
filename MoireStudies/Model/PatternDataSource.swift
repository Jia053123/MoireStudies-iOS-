//
//  PatternController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

protocol PatternDataSource: UIViewController {
    func modifyPattern(speed: CGFloat, caller: CtrlViewController) -> Bool
    func modifyPattern(direction: CGFloat, caller: CtrlViewController) -> Bool
    func modifyPattern(fillRatio: CGFloat, caller: CtrlViewController) -> Bool
    func modifyPattern(scaleFactor: CGFloat, caller: CtrlViewController) -> Bool
    func getPattern(caller: CtrlViewController) -> Pattern?
}
