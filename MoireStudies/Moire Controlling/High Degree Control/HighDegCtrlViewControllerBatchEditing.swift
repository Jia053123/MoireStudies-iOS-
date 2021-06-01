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
    private(set) var initPatterns: Array<Pattern?>
    private var basePatterns: Array<Pattern>? /// the basis of adjusments and multiplier calculations; refreshes every time matchControlsWithModel is called
    
    required init(id: String, frame: CGRect, patterns: Array<Pattern?>) {
        self.id = id
        self.initPatterns = patterns
        super.init(nibName: nil, bundle: nil)
        
        let controlView: HighDegreeCtrlView = SliderHighDegreeCtrlView.init(frame: frame)
        self.view = controlView
        controlView.target = self
        self.matchControlsWithModel(patterns: patterns)
    }
    
    required init?(coder: NSCoder) {
        self.initPatterns = []
        super.init(coder: coder)
    }
    
    /// call this after init or after any external changes being applied to the moire
    private func updateBasePatterns() {
        self.basePatterns = self.patternsDelegate.retrievePatterns(callerId: self.id)
    }
    
    func adjustRelativeSpeed(netMultiplier: CGFloat) {
        if basePatterns == nil {
            self.updateBasePatterns()
        }
        if let bp = basePatterns {
            for i in 0..<bp.count {
                _ = self.modifyPattern(index: i, speed: bp[i].speed * netMultiplier)
            }
        }
    }
    
    func adjustAllDirection(netAdjustment: CGFloat) {
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

    func adjustAllFillRatio(netMultiplier: CGFloat) {
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
    
    func adjustAllScale(netAdjustment: CGFloat) {
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
    func mostConservativeSpeedMultiplierRange(patterns: Array<Pattern?>) -> ClosedRange<CGFloat>? {
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
    
    func mostConservativeFillRatioMultiplierRange(patterns: Array<Pattern?>) -> ClosedRange<CGFloat>? {
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
    
    func mostConservativeScaleFactorAdjustmentRange(patterns: Array<Pattern?>) -> ClosedRange<CGFloat>? {
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
            cv.resetSpeedControl(range: mcsmr, value: 1.0)
        }
        cv.resetDirectionControl(range: -1*CGFloat.pi...CGFloat.pi, value: 0.0)
        if let mcfrmr = self.mostConservativeFillRatioMultiplierRange(patterns: patterns) {
            cv.resetFillRatioControl(range: mcfrmr, value: 1.0)
        }
        if let mcsfar = self.mostConservativeScaleFactorAdjustmentRange(patterns: patterns) {
            cv.resetScaleFactorControl(range: mcsfar, value: 0.0)
        }
    }
}
