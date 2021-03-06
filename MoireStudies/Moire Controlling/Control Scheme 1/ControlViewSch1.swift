//
//  ControlView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

protocol ControlViewSch1 : UIView {
    var target: BasicCtrlViewController? { get set }
    func matchControlsWithValues(speed: CGFloat, direction: CGFloat, fillRatio: CGFloat, scaleFactor: CGFloat)
}
