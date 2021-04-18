//
//  Utilities.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-01.
//

import Foundation
import UIKit

class Utilities: NSObject {
    static func convertToFillRatioAndScaleFactor(blackWidth: CGFloat, whiteWidth: CGFloat) -> (fillRatio: CGFloat, scaleFactor: CGFloat) {
        let fr: CGFloat = blackWidth / (blackWidth + whiteWidth)
        let sf: CGFloat = blackWidth / (fr * Constants.UI.tileHeight)
        return (fr, sf)
    }
    
    static func convertToBlackWidthAndWhiteWidth(fillRatio: CGFloat, scaleFactor: CGFloat) -> (blackWidth: CGFloat, whiteWidth: CGFloat) {
        let bw: CGFloat = fillRatio * Constants.UI.tileHeight * scaleFactor
        let ww: CGFloat = (1-fillRatio) * Constants.UI.tileHeight * scaleFactor
        return (bw, ww)
    }
    
    static func isWithinBounds(pattern: Pattern) -> Bool {
        if !BoundsManager.speedRange.contains(pattern.speed) {return false}
        if !BoundsManager.directionRange.contains(pattern.direction) {return false}
        if !BoundsManager.blackWidthRange.contains(pattern.blackWidth) {return false}
        if !BoundsManager.whiteWidthRange.contains(pattern.whiteWidth) {return false}
        return true
    }
    
    static func isWithinBounds(moire: Moire) -> Bool {
        for p in moire.patterns {
            if !Utilities.isWithinBounds(pattern: p) {
                return false
            }
        }
        return true
    }
    
    static func fitWithinBounds(pattern: Pattern) -> Pattern {
        var output = pattern
        
        if output.speed > BoundsManager.speedRange.upperBound {
            output.speed = BoundsManager.speedRange.upperBound
        } else if output.speed < BoundsManager.speedRange.lowerBound {
            output.speed = BoundsManager.speedRange.lowerBound
        }
        
        while output.direction > BoundsManager.directionRange.upperBound {
            output.direction -= 2*CGFloat.pi
        }
        
        while output.direction < BoundsManager.directionRange.lowerBound {
            output.direction += 2*CGFloat.pi
        }
        
        if output.blackWidth > BoundsManager.blackWidthRange.upperBound {
            output.blackWidth = BoundsManager.blackWidthRange.upperBound
        } else if output.blackWidth < BoundsManager.blackWidthRange.lowerBound {
            output.blackWidth = BoundsManager.blackWidthRange.lowerBound
        }
        
        if output.whiteWidth > BoundsManager.whiteWidthRange.upperBound {
            output.whiteWidth = BoundsManager.whiteWidthRange.upperBound
        } else if output.whiteWidth < BoundsManager.whiteWidthRange.lowerBound {
            output.whiteWidth = BoundsManager.whiteWidthRange.lowerBound
        }
        
        assert(Utilities.isWithinBounds(pattern: output))
        return output
    }
    
    static func fitWithinBounds(moire: Moire) -> Moire {
        let fittedMoire = moire.copy() as! Moire
        for i in 0..<fittedMoire.patterns.count {
            fittedMoire.patterns[i] = Utilities.fitWithinBounds(pattern: fittedMoire.patterns[i])
        }
        return fittedMoire
    }
    
    static func tryAccessArray<T>(array: Array<T>, index: Int) -> T? {
        let lastArrIndex = array.count - 1
        if index > lastArrIndex {
            return nil
        } else {
            return array[index]
        }
    }
}
