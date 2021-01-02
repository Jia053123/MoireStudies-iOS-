//
//  ControlViewSch2.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

protocol ControlViewSch2 : UIView {
    var target: PatternCtrlSch2Target? { get set }
    func matchControlsWithModel(pattern: Pattern)
}
