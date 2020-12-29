//
//  Pattern.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation

struct Pattern : Equatable {
    var speed: Double
    var direction: Double
    var fillRatio: Double
    var zoomRatio: Double
    
    static func defaultPattern() -> Pattern {
        return Pattern(speed: 20.0, direction: 0.0, fillRatio: 0.5, zoomRatio: 1.0)
    }
    
    static func randomPattern() -> Pattern {
        return Pattern(speed: Double.random(in: 10.0...20.0),
                       direction: Double.random(in: 0...360),
                       fillRatio: Double.random(in: 0.1...0.9),
                       zoomRatio: Double.random(in: 0.5...1.0))
    }
    
    
}
