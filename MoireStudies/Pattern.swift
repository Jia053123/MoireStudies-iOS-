//
//  Pattern.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

struct Pattern : Equatable {
    var speed: CGFloat
    var direction: CGFloat
    var fillRatio: CGFloat
    var zoomRatio: CGFloat
    
    static func defaultPattern() -> Pattern {
        return Pattern(speed: 10.0, direction: 0.0, fillRatio: 0.5, zoomRatio: 1.0)
    }
    
    static func randomPattern() -> Pattern {
        return Pattern(speed: CGFloat.random(in: 10.0...40.0),
                       direction: CGFloat.random(in: 0...2*CGFloat.pi),
                       fillRatio: CGFloat.random(in: 0.1...0.9),
                       zoomRatio: CGFloat.random(in: 1.0...2.0))
    }
    
    static func demoPattern1() -> Pattern {
        return Pattern(speed: 30.0,
                       direction: CGFloat.pi/4,
                       fillRatio: CGFloat.random(in: 0.3...0.7),
                       zoomRatio: CGFloat.random(in: 1.0...2.0))
    }
    
    static func demoPattern2() -> Pattern {
        return Pattern(speed: 30.0,
                       direction: CGFloat.pi/4.0 + 0.05 + CGFloat.pi*2.0,
                       fillRatio: CGFloat.random(in: 0.3...0.7),
                       zoomRatio: CGFloat.random(in: 1.3...1.7))
    }
}
