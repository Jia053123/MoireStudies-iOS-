//
//  ControlViewTargetProtocal.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation

protocol ControlViewTarget {
    func setSpeedTo(speed: Double) -> Bool
    func setDirectionTo(direction: Double) -> Bool
    func setFillRatioTo(fillRatio: Double) -> Bool
    func setZoomRatioTo(zoomRatio: Double) -> Bool
}
