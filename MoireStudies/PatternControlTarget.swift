//
//  ControlViewTargetProtocal.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

@objc protocol PatternControlTarget {
    func modifyPattern(speed: CGFloat) -> Bool
    func modifyPattern(direction: CGFloat) -> Bool
    func modifyPattern(fillRatio: CGFloat) -> Bool
    func modifyPattern(zoomRatio: CGFloat) -> Bool
}
