//
//  ControlViewSch2.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

protocol ControlViewSch2 : UIView {
    var target: CtrlViewSch2Target? { get set }
    func matchControlsWithValues(speed: CGFloat, direction: CGFloat, blackWidth: CGFloat, whiteWidth: CGFloat)
}
