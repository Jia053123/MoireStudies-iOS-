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
    
    static func intersectRanges<T>(range1: ClosedRange<T>, range2: ClosedRange<T>) -> ClosedRange<T>? {
        var largerLowerBound: T
        if range1.lowerBound < range2.lowerBound {
            largerLowerBound = range2.lowerBound
        } else {
            largerLowerBound = range1.lowerBound
        }
        var smallerUpperBound: T
        if range1.upperBound < range2.upperBound {
            smallerUpperBound = range1.upperBound
        } else {
            smallerUpperBound = range2.upperBound
        }
        
        if largerLowerBound <= smallerUpperBound {
            return largerLowerBound...smallerUpperBound
        } else {
            return nil
        }
    }
    
    /// Summary: Add padding to both ends of the range to make it more conservative; padding parameter will be applied as its absolute value; if the padding is so large such that the lower bound becomes greater than upper bound, the average of the lower bound and upper bound of closedRange parameter will be returned
    static func addPaddingsToRange(closedRange: ClosedRange<CGFloat>, padding: CGFloat) -> ClosedRange<CGFloat> {
        let posPadding = abs(padding)
        let lb = closedRange.lowerBound
        let ub = closedRange.upperBound
        let paddedLb = lb + posPadding
        let paddedUb = ub - posPadding
        if paddedLb <= paddedUb {
            return paddedLb...paddedUb
        } else {
            let avg = (lb + ub) / 2.0
            return avg...avg
        }
    }
}
