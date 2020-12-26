//
//  Pattern.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation

struct Pattern {
    var speed: Double
    var direction: Double
    var fillRatio: Double
    var zoomRatio: Double
    
    static func defaultPattern() -> Pattern {
        return Pattern(speed: 20.0, direction: 0.0, fillRatio: 0.5, zoomRatio: 1.0)
    }
}
