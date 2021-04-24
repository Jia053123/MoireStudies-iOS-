//
//  TestUtilities.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-04-19.
//

import Foundation
import UIKit
@testable import MoireStudies

class TestUtilities: NSObject {
    static func createValidPseudoRandomMoire(numOfPatterns: Int, seed: CGFloat) -> Moire {
        let newMoire = Moire()
        newMoire.resetData()
        let adjustment = seed.truncatingRemainder(dividingBy: 1.0)
        let basePattern = Pattern.init(speed: 10.0+adjustment, direction: 1.0+adjustment, blackWidth: 5.0+adjustment, whiteWidth: 6.0+adjustment)
        for i in 0..<numOfPatterns {
            let newPattern = Pattern.init(speed: basePattern.speed + CGFloat(i) * 0.01,
                                          direction: basePattern.direction + CGFloat(i) * 0.01,
                                          blackWidth: basePattern.blackWidth + CGFloat(i) * 0.01,
                                          whiteWidth: basePattern.whiteWidth + CGFloat(i) * 0.01)
            assert(BoundsManager.speedRange.contains(newPattern.speed))
            assert(BoundsManager.directionRange.contains(newPattern.direction))
            assert(BoundsManager.blackWidthRange.contains(newPattern.blackWidth))
            assert(BoundsManager.whiteWidthRange.contains(newPattern.whiteWidth))
            newMoire.patterns.append(newPattern)
        }
        return newMoire
    }
}
