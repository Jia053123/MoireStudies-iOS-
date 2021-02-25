//
//  ControlViewSch3.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-24.
//

import Foundation
import UIKit

protocol ControlViewSch3 : UIView {
    var target: CtrlViewControllerSch3? { get set }
    func matchControlsWithValues(speed: CGFloat, direction: CGFloat, blackWidth: CGFloat, whiteWidth: CGFloat, fillRatio: CGFloat, scaleFactor: CGFloat)
}
