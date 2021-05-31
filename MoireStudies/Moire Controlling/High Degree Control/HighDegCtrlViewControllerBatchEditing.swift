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
    let initPattern: Array<Pattern?>
    
    private var previousNetSpeedMultiplier: CGFloat = 1.0
    private var previousNetDirectionAdjustment: CGFloat = 0.0
    private var previousNetFillRatioMultiplier: CGFloat = 1.0
    private var previousNetScaleAdjustment: CGFloat = 0.0
    
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
    
    func adjustRelativeSpeed(netMultiplier: CGFloat) {
        guard let currentPatterns = self.patternsDelegate.retrievePatterns(callerId: self.id) else {return}
        let deltaMultiplier = netMultiplier - previousNetSpeedMultiplier
//        guard abs(deltaMultiplier) > 0.01 else {return}
        self.previousNetSpeedMultiplier = netMultiplier
        
        for i in 0..<currentPatterns.count {
            _ = self.modifyPattern(index: i, speed: currentPatterns[i].speed + currentPatterns[i].speed * deltaMultiplier)
        }
    }
    
    func adjustAllDirection(netAdjustment: CGFloat) {
        guard let currentPatterns = self.patternsDelegate.retrievePatterns(callerId: self.id) else {return}
        let deltaAdjustment = netAdjustment - previousNetDirectionAdjustment
        self.previousNetDirectionAdjustment = netAdjustment
        for i in 0..<currentPatterns.count {
            var newDirection = currentPatterns[i].direction + deltaAdjustment
            while newDirection > BoundsManager.directionRange.upperBound {
                newDirection -= 2*CGFloat.pi
            }
            while newDirection < BoundsManager.directionRange.lowerBound {
                newDirection += 2*CGFloat.pi
            }
            
            _ = self.modifyPattern(index: i, direction: newDirection)
        }
    }

    func adjustAllFillRatio(netMultiplier: CGFloat) {
        guard let currentPatterns = self.patternsDelegate.retrievePatterns(callerId: self.id) else {return}
        let deltaMultiplier = netMultiplier - previousNetFillRatioMultiplier
//        guard deltaMultiplier > 0.01 else {return}
        
        self.previousNetFillRatioMultiplier = netMultiplier
        
        for i in 0..<currentPatterns.count {
            let currentBlackWidth = currentPatterns[i].blackWidth
            let currentWhiteWidth = currentPatterns[i].whiteWidth
            let currentValues = Utilities.convertToFillRatioAndScaleFactor(blackWidth: currentBlackWidth, whiteWidth: currentWhiteWidth)
            let currentScaleFactor = currentValues.scaleFactor
            let currentFillRatio = currentValues.fillRatio
            let newFillRatio = currentFillRatio + currentFillRatio * deltaMultiplier
            let newValues = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: newFillRatio, scaleFactor: currentScaleFactor)
            _ = self.modifyPattern(index: i, blackWidth: newValues.blackWidth)
            _ = self.modifyPattern(index: i, whiteWidth: newValues.whiteWidth)
        }
    }
    
    func adjustAllScale(netAdjustment: CGFloat) {
        guard let currentPatterns = self.patternsDelegate.retrievePatterns(callerId: self.id) else {return}
        let deltaAdjustment = netAdjustment - previousNetScaleAdjustment
        self.previousNetScaleAdjustment = netAdjustment
        for i in 0..<currentPatterns.count {
            let currentBlackWidth = currentPatterns[i].blackWidth
            let currentWhiteWidth = currentPatterns[i].whiteWidth
            let currentValues = Utilities.convertToFillRatioAndScaleFactor(blackWidth: currentBlackWidth, whiteWidth: currentWhiteWidth)
            let currentFillRatio = currentValues.fillRatio
            let currentScaleFactor = currentValues.scaleFactor
            let newScaleFactor = currentScaleFactor + deltaAdjustment
            let newValues = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: currentFillRatio, scaleFactor: newScaleFactor)
            _ = self.modifyPattern(index: i, blackWidth: newValues.blackWidth)
            _ = self.modifyPattern(index: i, whiteWidth: newValues.whiteWidth)
        }
    }
}

extension HighDegCtrlViewControllerBatchEditing: HighDegCtrlViewController {
    func matchControlsWithModel(patterns: Array<Pattern?>) {
        var mostConservativeSpeedRange: ClosedRange<CGFloat>?
        var mostConservativeFillRatioRange : ClosedRange<CGFloat>?
        var mostConservativeScaleFactorRange: ClosedRange<CGFloat>?
        for pattern in patterns {
            guard let p = pattern else {continue}
            
            let speedMultiplierUpperBound1 = abs(BoundsManager.speedRange.lowerBound / p.speed)
            let speedMultiplierUpperBound2 = abs(BoundsManager.speedRange.upperBound / p.speed)
            let speedMultiplierUpperBound: CGFloat
            if speedMultiplierUpperBound1 > speedMultiplierUpperBound2 {
                speedMultiplierUpperBound = speedMultiplierUpperBound1
            } else {
                speedMultiplierUpperBound = speedMultiplierUpperBound2
            }
            
            if let mcsr = mostConservativeSpeedRange {
                mostConservativeSpeedRange = Utilities.intersectRanges(range1: mcsr, range2: 0.1...speedMultiplierUpperBound) // if it were 0 instead of 0.1, you cannot go back to original speed after going all the way to zero
            } else {
                mostConservativeSpeedRange = 0...speedMultiplierUpperBound
            }
            
            guard let boundResult = BoundsManager.calcBoundsForFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth) else {continue}
            
            let fillRatioMultiplierLowerBound = boundResult.fillRatioRange.lowerBound
            let fillRatioMultiplierUpperBound = boundResult.fillRatioRange.upperBound
            if let mcfrr = mostConservativeFillRatioRange {
                mostConservativeFillRatioRange = Utilities.intersectRanges(range1: mcfrr,
                                                                           range2: fillRatioMultiplierLowerBound...fillRatioMultiplierUpperBound)
            } else {
                mostConservativeFillRatioRange = fillRatioMultiplierLowerBound...fillRatioMultiplierUpperBound
            }
            
            let scaleFactorAdjustmentLowerBound = boundResult.scaleFactorRange.lowerBound
            let scaleFactorAdjustmentUpperBound = boundResult.scaleFactorRange.upperBound
            if let mcsfr = mostConservativeScaleFactorRange {
                mostConservativeScaleFactorRange = Utilities.intersectRanges(range1: mcsfr,
                                                                             range2: scaleFactorAdjustmentLowerBound...scaleFactorAdjustmentUpperBound)
            } else {
                mostConservativeScaleFactorRange = scaleFactorAdjustmentLowerBound...scaleFactorAdjustmentUpperBound
            }
        }
        
        let cv = self.view as! SliderHighDegreeCtrlView
        cv.matchControlsWithBounds(speedMultiplierRange: mostConservativeSpeedRange,
                                   fillRatioMultiplierRange: mostConservativeFillRatioRange,
                                   scaleFactorAdjustmentRange: mostConservativeScaleFactorRange)
    }
}
