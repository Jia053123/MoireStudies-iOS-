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
        if !Constants.Bounds.speedRange.contains(pattern.speed) {return false}
        if !Constants.Bounds.directionRange.contains(pattern.direction) {return false}
        if !Constants.Bounds.blackWidthRange.contains(pattern.blackWidth) {return false}
        if !Constants.Bounds.whiteWidthRange.contains(pattern.whiteWidth) {return false}
        return true
    }
}
