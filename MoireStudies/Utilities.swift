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
    
//    static func fitWithinBounds(pattern: Pattern) -> Pattern {
//
//    }
}
