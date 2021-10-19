//
//  HighDegreeCtrlViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-03-03.
//

import Foundation
import UIKit

class HighDegCtrlViewControllerBatchEditing: UIViewController, AbstractHighDegCtrlViewController {
    static let supportedNumOfPatterns: ClosedRange<Int> = 2...(Constants.Constrains.numOfPatternsPerMoire.upperBound)
    var id: String!
    var patternsDelegate: PatternManager!
    private(set) var initPattern: Array<Pattern?>
    private var basePatterns: Array<Pattern>? // the basis of adjusments and multiplier calculations; refreshes every time matchControlsWithModel is called
    
    required init(id: String, frame: CGRect, patterns: Array<Pattern?>) {
        self.id = id
        self.initPattern = patterns
        super.init(nibName: nil, bundle: nil)
        
        let controlView: HighDegreeCtrlView = SliderHighDegreeCtrlView.init(frame: frame)
        self.view = controlView
        controlView.target = self
        self.matchControlsWithModel(patterns: patterns)
    }
    
    required init?(coder: NSCoder) {
        self.initPattern = []
        super.init(coder: coder)
    }
    
    /// call this after init or after any external changes being applied to the moire
    private func updateBasePatterns() {
        self.basePatterns = self.patternsDelegate.retrievePatterns(callerId: self.id)
    }
    
    func modifyAllSpeed(netMultiplier: CGFloat) {
        if basePatterns == nil {
            self.updateBasePatterns()
        }
        if let bp = basePatterns {
            for i in 0..<bp.count {
                _ = self.modifyPattern(index: i, speed: bp[i].speed * netMultiplier)
            }
        }
    }
    
    private func calculateAverageSpeed(patterns: Array<Pattern?>) -> CGFloat {
        var speedSum: CGFloat = 0
        var count: Int = 0
        for pattern in patterns {
            guard let p = pattern else {continue}
            speedSum += p.speed
            count += 1
        }
        return speedSum / CGFloat(count)
    }
    
    func modifyAllSpeed(varianceFactor: CGFloat) {
        if basePatterns == nil {
            self.updateBasePatterns()
        }
        if let bps = basePatterns {
            let averageSpeed = self.calculateAverageSpeed(patterns: bps)
            for i in 0..<bps.count {
                let speed = bps[i].speed
                let difference = speed - averageSpeed
                let newDifference = difference * varianceFactor
                let delta = newDifference - difference
                let newSpeed = speed + delta
                _ = self.modifyPattern(index: i, speed: newSpeed)
            }
        }
    }
    
    private func getNormalizedDirectionForEachPattern(patterns: Array<Pattern>) -> Array<CGFloat> {
        var allDirectionsNormalized : Array<CGFloat> = []
        for i in 0..<patterns.count {
            allDirectionsNormalized.append(patterns[i].direction)
        }
        for i in 0..<allDirectionsNormalized.count {
            assert(allDirectionsNormalized[i] >= 0 && allDirectionsNormalized[i] <= CGFloat.pi*2)
            if (allDirectionsNormalized[i] > CGFloat.pi) {
                allDirectionsNormalized[i] -= CGFloat.pi
            }
        }
        return allDirectionsNormalized
    }
    
    private func calculateDirectionOfBisettingLineForSmallestAngle(normalizedDirections: Array<CGFloat>) -> CGFloat {
        guard normalizedDirections.count > 0 else {return 0}
        
        var normalizedDirectionsSorted = normalizedDirections
        normalizedDirectionsSorted.sort()
        // make sure the angle between the first and last one is taken into consideration
        normalizedDirectionsSorted.append(normalizedDirectionsSorted.first! + CGFloat.pi)
        
        var smallestAngleDifference: CGFloat = CGFloat.infinity
        var smallestAngleDifferenceAngleFrom: CGFloat = CGFloat.infinity
        var smallestAngleDifferenceAngleTo: CGFloat = CGFloat.infinity
        for i in 0..<normalizedDirectionsSorted.count - 1 {
            let angleFrom = normalizedDirectionsSorted[i]
            let angleTo = normalizedDirectionsSorted[i+1]
            let angleDifference = angleTo - angleFrom
            if (angleDifference < smallestAngleDifference) {
                smallestAngleDifference = angleDifference
                smallestAngleDifferenceAngleFrom = angleFrom
                smallestAngleDifferenceAngleTo = angleTo
            }
        }
        var bisectingLineDirection = (smallestAngleDifferenceAngleFrom + smallestAngleDifferenceAngleTo) / 2.0
        if (bisectingLineDirection > CGFloat.pi) {
            bisectingLineDirection -= CGFloat.pi
        }
        return bisectingLineDirection
    }
    
    func modifyAllDirection(convergenceFactor: CGFloat) {
        if basePatterns == nil {
            self.updateBasePatterns()
        }
        
        if let bps = basePatterns {
            let allDirectionsNormalized = getNormalizedDirectionForEachPattern(patterns: bps)
            let bisectingLineDirection = calculateDirectionOfBisettingLineForSmallestAngle(normalizedDirections: allDirectionsNormalized)
            
            // rotate all patterns towards the bisecting line by convergenceFactor
            assert(bisectingLineDirection <= CGFloat.pi)
            assert(allDirectionsNormalized.count == bps.count)
            for i in 0..<allDirectionsNormalized.count {
                let normalizedDirection = allDirectionsNormalized[i]
                var difference = normalizedDirection - bisectingLineDirection
                if (difference > CGFloat.pi/2) {
                    difference -= CGFloat.pi
                }
                if (difference < -1*CGFloat.pi/2) {
                    difference += CGFloat.pi
                }
                let newDifference = difference * convergenceFactor
                let angleToRotate = newDifference - difference
                var newDirection =  bps[i].direction + angleToRotate
                
                while newDirection > BoundsManager.directionRange.upperBound {
                    newDirection -= 2*CGFloat.pi
                }
                while newDirection < BoundsManager.directionRange.lowerBound {
                    newDirection += 2*CGFloat.pi
                }
                _ = self.modifyPattern(index: i, direction: newDirection)
            }
        }
    }
    
    func modifyAllDirection(netAdjustment: CGFloat) {
        if basePatterns == nil {
            self.updateBasePatterns()
        }
        if let bp = basePatterns {
            for i in 0..<bp.count {
                var newDirection = bp[i].direction + netAdjustment
                while newDirection > BoundsManager.directionRange.upperBound {
                    newDirection -= 2*CGFloat.pi
                }
                while newDirection < BoundsManager.directionRange.lowerBound {
                    newDirection += 2*CGFloat.pi
                }
                _ = self.modifyPattern(index: i, direction: newDirection)
            }
        }
    }
    
    private func calculateAverageWhiteWidth(patterns: Array<Pattern?>) -> CGFloat {
        var whiteWidthSum: CGFloat = 0
        var count: Int = 0
        for pattern in patterns {
            guard let p = pattern else {continue}
            whiteWidthSum += p.whiteWidth
            count += 1
        }
        return whiteWidthSum / CGFloat(count)
    }
    
    func modifyAllWhiteWidth(phaseMergeFactor: CGFloat) {
        if basePatterns == nil {
            self.updateBasePatterns()
        }
        if let bps = basePatterns {
            let averageWhiteWidth = calculateAverageWhiteWidth(patterns: bps)
            
            for i in 0..<bps.count {
                let whiteWidth = bps[i].whiteWidth
                let difference = whiteWidth - averageWhiteWidth
                let newDifference = difference * phaseMergeFactor
                let delta = newDifference - difference
                let newWhiteWidth = whiteWidth + delta
                _ = self.modifyPattern(index: i, whiteWidth: newWhiteWidth)
            }
        }
    }

    func modifyAllFillRatio(netMultiplier: CGFloat) {
        if basePatterns == nil {
            self.updateBasePatterns()
        }
        if let bp = basePatterns {
            for i in 0..<bp.count {
                let baseBlackWidth = bp[i].blackWidth
                let baseWhiteWidth = bp[i].whiteWidth
                let baseValues = Utilities.convertToFillRatioAndScaleFactor(blackWidth: baseBlackWidth, whiteWidth: baseWhiteWidth)
                let baseFillRatio = baseValues.fillRatio
                let baseScaleFactor = baseValues.scaleFactor
                let newValues = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: baseFillRatio*netMultiplier, scaleFactor: baseScaleFactor)
                _ = self.modifyPattern(index: i, blackWidth: newValues.blackWidth)
                _ = self.modifyPattern(index: i, whiteWidth: newValues.whiteWidth)
            }
        }
    }
    
    func modifyAllScale(netAdjustment: CGFloat) {
        if basePatterns == nil {
            self.updateBasePatterns()
        }
        if let bps = basePatterns {
            for i in 0..<bps.count {
                let baseBlackWidth = bps[i].blackWidth
                let baseWhiteWidth = bps[i].whiteWidth
                let baseValues = Utilities.convertToFillRatioAndScaleFactor(blackWidth: baseBlackWidth, whiteWidth: baseWhiteWidth)
                let baseFillRatio = baseValues.fillRatio
                let baseScaleFactor = baseValues.scaleFactor
                let newValues = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: baseFillRatio, scaleFactor: baseScaleFactor + netAdjustment)
                _ = self.modifyPattern(index: i, blackWidth: newValues.blackWidth)
                _ = self.modifyPattern(index: i, whiteWidth: newValues.whiteWidth)
            }
        }
    }
    
    func modifyAllScale(netMultiplier: CGFloat) {
        NSLog("modifyAllScale not implemented")
    }
}

extension HighDegCtrlViewControllerBatchEditing: HighDegCtrlViewController {
    private func mostConservativeSpeedMultiplierRange(patterns: Array<Pattern?>) -> ClosedRange<CGFloat>? {
        var result: ClosedRange<CGFloat>?
        for pattern in patterns {
            guard let p = pattern else {continue}
            let speedMultiplierUpperBound1 = abs(BoundsManager.speedRange.lowerBound / p.speed)
            let speedMultiplierUpperBound2 = abs(BoundsManager.speedRange.upperBound / p.speed)
            let speedMultiplierUpperBound = (speedMultiplierUpperBound1 > speedMultiplierUpperBound2) ? speedMultiplierUpperBound1 : speedMultiplierUpperBound2
            
            if let mcsr = result {
                result = Utilities.intersectRanges(range1: mcsr, range2: 0.1...speedMultiplierUpperBound) // if it were 0 instead of 0.1, you cannot go back to the original speed after going all the way to 0 because 0 times anything is 0
            } else {
                result = 0...speedMultiplierUpperBound
            }
        }
        return result
    }
    
    private func mostConservativeSpeedVarianceFactorRange(patterns: Array<Pattern?>) -> ClosedRange<CGFloat>? {
        var result: ClosedRange<CGFloat>?
        let averageSpeed = calculateAverageSpeed(patterns: patterns)
        for pattern in patterns {
            guard let p = pattern else {continue}
            let speed = p.speed
            let difference = speed - averageSpeed
            
            let maxDelta = BoundsManager.speedRange.upperBound - speed
            let minDelta = BoundsManager.speedRange.lowerBound - speed
            
            let maxNewDifference = maxDelta + difference
            let minNewDifference = minDelta + difference
            
            let factor1 = maxNewDifference / difference
            let factor2 = minNewDifference / difference
            let maxFactor = factor1 > factor2 ? factor1 : factor2
            let minFactor = factor1 > factor2 ? factor2 : factor1
            
            if let mcsvfr = result {
                result = Utilities.intersectRanges(range1: mcsvfr, range2: minFactor...maxFactor)
            } else {
                result = minFactor...maxFactor
            }
        }
        return result
    }
    
    private func mostConservativePhaseMergeFactorRange(patterns: Array<Pattern?>) -> ClosedRange<CGFloat>?{
        let minFactor: CGFloat = 0.001
        var result: ClosedRange<CGFloat>?
        let averageWhiteWidth = calculateAverageWhiteWidth(patterns: patterns)
        for pattern in patterns {
            guard let p = pattern else {continue}
            let whiteWidth = p.whiteWidth
            let difference = whiteWidth - averageWhiteWidth
            
            let maxDelta = BoundsManager.whiteWidthRange.upperBound - whiteWidth
            let minDelta = BoundsManager.whiteWidthRange.lowerBound - whiteWidth
            
            let maxNewDifference = maxDelta + difference
            let minNewDifference = minDelta + difference
            
            let maxFactor1 = maxNewDifference / difference
            let maxFactor2 = minNewDifference / difference
            let maxFactor = maxFactor1 > maxFactor2 ? maxFactor1 : maxFactor2
            
            if let mcpmfr = result {
                result = Utilities.intersectRanges(range1: mcpmfr, range2: minFactor...maxFactor)
            } else {
                result = minFactor...maxFactor
            }
        }
        return result
    }
    
    private func mostConservativeFillRatioMultiplierRange(patterns: Array<Pattern?>) -> ClosedRange<CGFloat>? {
        var result : ClosedRange<CGFloat>?
        for pattern in patterns {
            guard let p = pattern else {continue}
            guard let boundResult = BoundsManager.calcBoundsForFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth) else {continue}
            
            let curretFillRatio = Utilities.convertToFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth).fillRatio
            let fillRatioMultiplierLowerBound = boundResult.fillRatioRange.lowerBound / curretFillRatio
            let fillRatioMultiplierUpperBound = boundResult.fillRatioRange.upperBound / curretFillRatio
            if let mcfrr = result {
                result = Utilities.intersectRanges(range1: mcfrr,
                                                   range2: fillRatioMultiplierLowerBound...fillRatioMultiplierUpperBound)
            } else {
                result = fillRatioMultiplierLowerBound...fillRatioMultiplierUpperBound
            }
        }
        return result
    }
    
    private func mostConservativeScaleFactorAdjustmentRange(patterns: Array<Pattern?>) -> ClosedRange<CGFloat>? {
        var result: ClosedRange<CGFloat>?
        for pattern in patterns {
            guard let p = pattern else {continue}
            guard let boundResult = BoundsManager.calcBoundsForFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth) else {continue} 
            
            let currentScaleFactor = Utilities.convertToFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth).scaleFactor
            let scaleFactorAdjustmentLowerBound = boundResult.scaleFactorRange.lowerBound - currentScaleFactor
            let scaleFactorAdjustmentUpperBound = boundResult.scaleFactorRange.upperBound - currentScaleFactor
            if let mcsfr = result {
                result = Utilities.intersectRanges(range1: mcsfr,
                                                   range2: scaleFactorAdjustmentLowerBound...scaleFactorAdjustmentUpperBound)
            } else {
                result = scaleFactorAdjustmentLowerBound...scaleFactorAdjustmentUpperBound
            }
        }
        return result
    }
    
    func matchControlsWithModel(patterns: Array<Pattern?>) {
        self.basePatterns = nil // reset basePatterns after external changes to the moire
        
        let cv = self.view as! SliderHighDegreeCtrlView
        
        cv.resetDirectionControl(range: -1*CGFloat.pi...CGFloat.pi, value: 0.0)
        
        if let mcsmr = self.mostConservativeSpeedVarianceFactorRange(patterns: patterns) {
            cv.resetSpeedControl(range: Utilities.addPaddingsToRange(closedRange: mcsmr, padding: 0.001), value: 1.0)
        }
        
        cv.resetConvergenceControl(range: 0.1...3, value: 1.0)
        
        if let mcpmfr = self.mostConservativePhaseMergeFactorRange(patterns: patterns) {
            cv.resetPhaseControl(range: mcpmfr, value: 1.0)
        }
                
        if let mcfrmr = self.mostConservativeFillRatioMultiplierRange(patterns: patterns) {
            cv.resetFillRatioControl(range: Utilities.addPaddingsToRange(closedRange: mcfrmr, padding: 0.001), value: 1.0)
        }
        if let mcsfar = self.mostConservativeScaleFactorAdjustmentRange(patterns: patterns) {
            cv.resetScaleFactorControl(range: Utilities.addPaddingsToRange(closedRange: mcsfar, padding: 0.001), value: 0.0)
        }
    }
    
    func matchControlsWithUpdatedModel() {
        self.matchControlsWithModel(patterns: self.patternsDelegate.retrievePatterns(callerId: self.id)!)
    }
}

extension HighDegCtrlViewControllerBatchEditing {
    func removeThisControl(){
        self.patternsDelegate.removeHighDegControl(id: self.id)
    }
}
