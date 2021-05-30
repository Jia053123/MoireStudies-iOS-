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
        let relativeMultiplier = netMultiplier - previousNetSpeedMultiplier
        self.previousNetSpeedMultiplier = netMultiplier
        for i in 0..<currentPatterns.count {
            _ = self.modifyPattern(index: i, speed: currentPatterns[i].speed + currentPatterns[i].speed * relativeMultiplier)
        }
    }
    
    func adjustAllDirection(netAdjustment: CGFloat) {
        // rotate the whole moire
        guard let currentPatterns = self.patternsDelegate.retrievePatterns(callerId: self.id) else {return}
        let relativeAdjustment = netAdjustment - previousNetDirectionAdjustment
        self.previousNetDirectionAdjustment = netAdjustment
        for i in 0..<currentPatterns.count {
            _ = self.modifyPattern(index: i, direction: currentPatterns[i].direction + relativeAdjustment)
        }
    }
    
    func adjustAllBlackWidth(by increment: CGFloat) {
        // increase and decrease the width
        for i in 0..<self.initPattern.count {
            _ = self.modifyPattern(index: i, blackWidth: increment)
        }
    }
    
    func adjustAllWhiteWidth(by increment: CGFloat) {
        // increase and decrease the width
        for i in 0..<self.initPattern.count {
            _ = self.modifyPattern(index: i, whiteWidth: increment)
        }
    }
}

extension HighDegCtrlViewControllerBatchEditing: HighDegCtrlViewController {
    func matchControlsWithModel(patterns: Array<Pattern?>) {
        // stub
    }
}
