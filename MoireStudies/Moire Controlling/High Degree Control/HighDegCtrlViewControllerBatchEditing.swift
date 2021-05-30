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
            _ = self.modifyPattern(index: i, direction: currentPatterns[i].direction + deltaAdjustment)
        }
    }

    func adjustAllFillRatio(netMultiplier: CGFloat) {
        guard let currentPatterns = self.patternsDelegate.retrievePatterns(callerId: self.id) else {return}
        let deltaMultiplier = netMultiplier - previousNetFillRatioMultiplier
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
        let cv = self.view as! SliderHighDegreeCtrlView
        
        var speedBound: ClosedRange<CGFloat>?
        var fillRatioBound : ClosedRange<CGFloat>?
        var scaleFactorBound: ClosedRange<CGFloat>?
        for p in patterns {
            guard let pattern = p else {continue}
            guard let boundResult = BoundsManager.calcBoundsForFillRatioAndScaleFactor(blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth) else {continue}
            if let frb = fillRatioBound, let sfb = scaleFactorBound {
                if frb.lowerBound < boundResult.fillRatioRange.lowerBound {
                    fillRatioBound = boundResult.fillRatioRange.lowerBound...frb.upperBound
                }
                if frb.upperBound > boundResult.fillRatioRange.upperBound {
                    fillRatioBound = frb.lowerBound...boundResult.fillRatioRange.upperBound
                }
            }
        }
        
        cv.matchControlsWithBounds(speedRange: speedBound, fillRatioRange: fillRatioBound, scaleRange: scaleFactorBound)
    }
}
