//
//  ControlViewTargetProtocal.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation

@objc protocol PatternControlTarget {
    func modifyPattern(speed: Double) -> Bool
    func modifyPattern(direction: Double) -> Bool
    func modifyPattern(fillRatio: Double) -> Bool
    func modifyPattern(zoomRatio: Double) -> Bool
}
