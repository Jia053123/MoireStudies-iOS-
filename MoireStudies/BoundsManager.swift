//
//  BoundsManager.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-03-25.
//

import Foundation
import UIKit

class BoundsManager: NSObject {
    static let speedRange: ClosedRange<CGFloat> = -50.0...50.0
    static let directionRange: ClosedRange<CGFloat> = 0.0...CGFloat.pi*2
    static let blackWidthRange: ClosedRange<CGFloat> = 2.0...25.0
    static let whiteWidthRange: ClosedRange<CGFloat> = 2.0...25.0
    
    static func calcBoundsForFillRatioAndScaleFactor(blackWidth: CGFloat, whiteWidth: CGFloat) ->
    (fillRatioRange: ClosedRange<CGFloat>, scaleFactorRange: ClosedRange<CGFloat>)? {
        // sanitize input
        guard BoundsManager.blackWidthRange.contains(blackWidth) &&
                BoundsManager.whiteWidthRange.contains(whiteWidth) else {return nil}
        
        // calculate min and max fill ratio (fix scale factor reflected through combined width)
        let currentCombinedWidth = blackWidth + whiteWidth
        var fillRatioBreakingPoints: Array<CGFloat> = []
        // case 1: blackWidth at min
        let frCase1BlackWidth = BoundsManager.blackWidthRange.lowerBound
        let frCase1WhiteWidth = currentCombinedWidth - frCase1BlackWidth
        if BoundsManager.whiteWidthRange.contains(frCase1WhiteWidth) {
            fillRatioBreakingPoints.append(frCase1BlackWidth / currentCombinedWidth)
        }
        // case 2: blackWidth at max
        let frCase2BlackWidth = BoundsManager.blackWidthRange.upperBound
        let frCase2WhiteWidth = currentCombinedWidth - frCase2BlackWidth
        if BoundsManager.whiteWidthRange.contains(frCase2WhiteWidth) {
            fillRatioBreakingPoints.append(frCase2BlackWidth / currentCombinedWidth)
        }
        // case 3: whiteWidth at min
        let frCase3WhiteWidth = BoundsManager.whiteWidthRange.lowerBound
        let frCase3BlackWidth = currentCombinedWidth - frCase3WhiteWidth
        if BoundsManager.blackWidthRange.contains(frCase3BlackWidth) {
            fillRatioBreakingPoints.append(frCase3BlackWidth / currentCombinedWidth)
        }
        // case 4: whiteWidth at max
        let frCase4WhiteWidth = BoundsManager.whiteWidthRange.upperBound
        let frCase4BlackWidth = currentCombinedWidth - frCase4WhiteWidth
        if BoundsManager.blackWidthRange.contains(frCase4BlackWidth) {
            fillRatioBreakingPoints.append(frCase4BlackWidth / currentCombinedWidth)
        }
        // find min and max
        var minFR = fillRatioBreakingPoints.first!
        var maxFR = fillRatioBreakingPoints.last!
        for fr in fillRatioBreakingPoints {
            if fr < minFR { minFR = fr}
            if fr > maxFR { maxFR = fr}
        }
        
        // calculate min and max scale factor (fix fill ratio)
        let currentFillRatio = blackWidth / currentCombinedWidth
        let baseCombinedWidth = BoundsManager.blackWidthRange.lowerBound + BoundsManager.whiteWidthRange.lowerBound
        var scaleFactorBreakingPoints: Array<CGFloat> = []
        // case 1: blackWidth at min
        let sfCase1BlackWidth = BoundsManager.blackWidthRange.lowerBound
        let sfCase1WhiteWidth = sfCase1BlackWidth / currentFillRatio - sfCase1BlackWidth
        if BoundsManager.whiteWidthRange.contains(sfCase1WhiteWidth) {
            scaleFactorBreakingPoints.append((sfCase1BlackWidth + sfCase1WhiteWidth) / baseCombinedWidth)
        }
        // case 2: whiteWidth at min
        let sfCase2WhiteWidth = BoundsManager.whiteWidthRange.lowerBound
        let sfCase2BlackWidth = sfCase2WhiteWidth / (1-currentFillRatio) - sfCase2WhiteWidth
        if BoundsManager.blackWidthRange.contains(sfCase2BlackWidth) {
            scaleFactorBreakingPoints.append((sfCase2BlackWidth + sfCase2WhiteWidth) / baseCombinedWidth)
        }
        // case 3: blackWidth at max
        let sfCase3BlackWidth = BoundsManager.blackWidthRange.upperBound
        let sfCase3WhiteWidth =  sfCase3BlackWidth / currentFillRatio - sfCase3BlackWidth
        if BoundsManager.whiteWidthRange.contains(sfCase3WhiteWidth) {
            scaleFactorBreakingPoints.append((sfCase3BlackWidth + sfCase3WhiteWidth) / baseCombinedWidth)
        }
        // case 4: whiteWidth at max
        let sfCase4WhiteWidth = BoundsManager.whiteWidthRange.upperBound
        let sfCase4BlackWidth = sfCase4WhiteWidth / (1-currentFillRatio) - sfCase4WhiteWidth
        if BoundsManager.blackWidthRange.contains(sfCase4BlackWidth) {
            scaleFactorBreakingPoints.append((sfCase4BlackWidth + sfCase4WhiteWidth) / baseCombinedWidth)
        }
        // find min and max
        var minSF = scaleFactorBreakingPoints.first!
        var maxSF = scaleFactorBreakingPoints.last!
        for sf in scaleFactorBreakingPoints {
            if sf < minSF { minSF = sf}
            if sf > maxSF { maxSF = sf}
        }
        
        return (fillRatioRange: minFR...maxFR, scaleFactorRange: minSF...maxSF)
    }
}
