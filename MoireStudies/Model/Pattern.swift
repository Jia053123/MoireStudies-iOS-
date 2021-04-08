//
//  Pattern.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

struct Pattern: Equatable, Codable {
    var speed: CGFloat // unit: point/sec
    var direction: CGFloat // unit: rad
    var blackWidth: CGFloat // unit: point
    var whiteWidth: CGFloat // unit: point
    
    static func debugPattern() -> Pattern {
        return Pattern(speed: 10.0, direction: 0.0, blackWidth: 10, whiteWidth: 20)
    }
    
    static func defaultPattern() -> Pattern {
        let r = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: 0.5, scaleFactor: 1.0)
        return Pattern(speed: 10.0, direction: 0.0, blackWidth: r.blackWidth, whiteWidth: r.whiteWidth)
    }
    
    static func randomPattern() -> Pattern {
        return Pattern(speed: CGFloat.random(in: BoundsManager.speedRange),
                       direction: CGFloat.random(in: BoundsManager.directionRange),
                       blackWidth: CGFloat.random(in: BoundsManager.blackWidthRange),
                       whiteWidth: CGFloat.random(in: BoundsManager.whiteWidthRange))
    }
    
    static func randomDemoPattern() -> Pattern {
        let r = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: CGFloat.random(in: 0.3...0.7),
                                                           scaleFactor: CGFloat.random(in: 1.0...4.0))
        return Pattern(speed: CGFloat.random(in: 0.0...20.0),
                       direction: CGFloat.pi/4 + CGFloat.random(in: -0.3...0.3) + [CGFloat(0.0), CGFloat.pi].randomElement()!,
                       blackWidth: r.blackWidth,
                       whiteWidth: r.whiteWidth)
    }
    
    static func demoPattern1() -> Pattern {
        let r = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: CGFloat.random(in: 0.3...0.7),
                                                           scaleFactor: CGFloat.random(in: 1.6...2.9))
        return Pattern(speed: 10.0, direction: CGFloat.pi/4, blackWidth: r.blackWidth, whiteWidth: r.whiteWidth)
    }
    
    static func demoPattern2() -> Pattern {
        let r = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: CGFloat.random(in: 0.3...0.7),
                                                           scaleFactor: CGFloat.random(in: 1.3...2.6))
        return Pattern(speed: 15.0, direction: CGFloat.pi/4.0 + 0.025, blackWidth: r.blackWidth, whiteWidth: r.whiteWidth)
    }
    
    static func demoPattern3() -> Pattern {
        let r = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: CGFloat.random(in: 0.3...0.7),
                                                           scaleFactor: CGFloat.random(in: 1.0...2.3))
        return Pattern(speed: 20.0, direction: CGFloat.pi/4.0 + 0.5, blackWidth: r.blackWidth, whiteWidth: r.whiteWidth)
    }
    
    static func demoPattern4() -> Pattern {
        let r = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: CGFloat.random(in: 0.3...0.7),
                                                           scaleFactor: CGFloat.random(in: 1.9...3.2))
        return Pattern(speed: 5.0, direction: CGFloat.pi/4.0 - 0.025, blackWidth: r.blackWidth, whiteWidth: r.whiteWidth)
    }
    
    static func demoPattern5() -> Pattern {
        let r = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: CGFloat.random(in: 0.3...0.7),
                                                           scaleFactor: CGFloat.random(in: 2.2...3.5))
        return Pattern(speed: 0.0, direction: CGFloat.pi/4.0 - 0.5, blackWidth: r.blackWidth, whiteWidth: r.whiteWidth)
    }
}
