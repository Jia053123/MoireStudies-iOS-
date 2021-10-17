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
    
    func modifyAllDirection(convergenceFactor: CGFloat) {
        if basePatterns == nil {
            self.updateBasePatterns()
        }
        
        if let bp = basePatterns {
            // Step1: get, normalize and sort directions from each pattern
            var allDirectionsNormalized : Array<CGFloat> = []
            for i in 0..<bp.count {
                allDirectionsNormalized.append(bp[i].direction)
            }
            for i in 0..<allDirectionsNormalized.count {
                assert(allDirectionsNormalized[i] >= 0 && allDirectionsNormalized[i] <= CGFloat.pi*2)
                if (allDirectionsNormalized[i] > CGFloat.pi) {
                    allDirectionsNormalized[i] -= CGFloat.pi
                }
            }
            var allDirectionsNormalizedSorted = allDirectionsNormalized
            allDirectionsNormalizedSorted.sort()
            
            // Step2: find the two smallest opposite angles (they are identitical in value), and find the direction of the bisetting line
            var smallestAngleDifference: CGFloat = CGFloat.infinity
            var smallestAngleDifferenceAngleFrom: CGFloat = CGFloat.infinity
            var smallestAngleDifferenceAngleTo: CGFloat = CGFloat.infinity
            for i in 0..<allDirectionsNormalizedSorted.count - 1 {
                let angleFrom = allDirectionsNormalizedSorted[i]
                let angleTo = allDirectionsNormalizedSorted[i+1]
                let angleDifference = angleTo - angleFrom
                if (angleDifference < smallestAngleDifference) {
                    smallestAngleDifference = angleDifference
                    smallestAngleDifferenceAngleFrom = angleFrom
                    smallestAngleDifferenceAngleTo = angleTo
                }
            }
            let bisectingLineDirection = (smallestAngleDifferenceAngleFrom + smallestAngleDifferenceAngleTo) / 2.0
            
            // Step3:  rotate all patterns towards the bisecting line by convergenceFactor
            assert(bisectingLineDirection <= CGFloat.pi)
            assert(allDirectionsNormalized.count == bp.count)
            for i in 0..<allDirectionsNormalized.count {
                let direction = allDirectionsNormalized[i]
                let difference = direction - bisectingLineDirection
                let newDifference = difference * convergenceFactor
                let angleToRotate = newDifference - difference
                var newDirection =  bp[i].direction + angleToRotate
                
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
    
    func modifyAllWhiteWidth(phaseMergeFactor: CGFloat) {
        if basePatterns == nil {
            self.updateBasePatterns()
        }
        if let bp = basePatterns {
            var whiteWidthSum: CGFloat = 0
            for i in 0..<bp.count {
                whiteWidthSum += bp[i].whiteWidth
            }
            let averageWhiteWidth = whiteWidthSum / CGFloat(bp.count)
            
            for i in 0..<bp.count {
                let whiteWidth = bp[i].whiteWidth
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
        if let bp = basePatterns {
            for i in 0..<bp.count {
                let baseBlackWidth = bp[i].blackWidth
                let baseWhiteWidth = bp[i].whiteWidth
                let baseValues = Utilities.convertToFillRatioAndScaleFactor(blackWidth: baseBlackWidth, whiteWidth: baseWhiteWidth)
                let baseFillRatio = baseValues.fillRatio
                let baseScaleFactor = baseValues.scaleFactor
                let newValues = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: baseFillRatio, scaleFactor: baseScaleFactor+netAdjustment)
                _ = self.modifyPattern(index: i, blackWidth: newValues.blackWidth)
                _ = self.modifyPattern(index: i, whiteWidth: newValues.whiteWidth)
            }
        }
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
    
    private func mostConservativeConvergenceMultiplierRange(patterns: Array<Pattern?>) -> ClosedRange<CGFloat>? {
        return 0.02...2
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
        if let mcsmr = self.mostConservativeSpeedMultiplierRange(patterns: patterns) {
            cv.resetSpeedControl(range: Utilities.addPaddingsToRange(closedRange: mcsmr, padding: 0.0001), value: 1.0)
        }
        
        if let mccmr = self.mostConservativeConvergenceMultiplierRange(patterns: patterns) {
            cv.resetConvergenceControl(range: mccmr, value: 1.0)
        }
                
        if let mcfrmr = self.mostConservativeFillRatioMultiplierRange(patterns: patterns) {
            cv.resetFillRatioControl(range: Utilities.addPaddingsToRange(closedRange: mcfrmr, padding: 0.0001), value: 1.0)
        }
        if let mcsfar = self.mostConservativeScaleFactorAdjustmentRange(patterns: patterns) {
            cv.resetScaleFactorControl(range: Utilities.addPaddingsToRange(closedRange: mcsfar, padding: 0.0001), value: 0.0)
        }
    }
    
    func matchControlsWithUpdatedModel() {
        self.matchControlsWithModel(patterns: self.patternsDelegate.retrievePatterns(callerId: self.id)!)
    }
}
