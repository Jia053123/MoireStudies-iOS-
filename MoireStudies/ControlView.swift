//
//  ControlView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

protocol ControlView : UIView {
    var target: PatternControlTarget? { get set }
    func matchControlsWithModel(pattern: Pattern)
}
