//
//  MoireView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-17.
//

import UIKit
import Foundation
/**
 SubViews hierachy:
 - MainView
    - UIButton
    - ControlsView
        - ControlView (n)
    - MoireView (1)
        - DimView (0..1)
        - PatternView (n)
            - MaskView(1) in mask property
 */
class MainView: UIView {
    typealias PatternViewClass = CoreAnimPatternView
    private var moireView: UIView = UIView()
    private var patternViews: Array<PatternView> = []
    private var highlightedViews: Array<PatternView> = []
    private var maskViews: Array<MaskView> = []
    private var dimView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initHelper()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initHelper()
    }
    
    func initHelper() {
        self.backgroundColor = UIColor.white
        self.addSubview(moireView)
    }
    
    func setUp(patterns: Array<Pattern>) {
        self.resetMoireView(patterns: patterns)
    }
    
    func resetMoireView(patterns: Array<Pattern>) {
        self.moireView.frame = self.bounds
        for sv in self.moireView.subviews {
            sv.removeFromSuperview()
        }
        patternViews = []
        for pattern in patterns {
            let newPatternView: PatternView = PatternViewClass.init(frame: self.moireView.bounds)
            patternViews.append(newPatternView)
            self.moireView.addSubview(newPatternView)
            newPatternView.setUpAndRender(pattern: pattern)
        }
    }
    
    func setUpMaskOnPatternView(patternIndex: Int, controlViewFrame: CGRect) {
        let maskView = MaskView.init(frame: self.moireView.bounds, maskFrame: controlViewFrame)
        patternViews[patternIndex].mask = maskView
    }
    
    func highlightPatternView(patternViewIndex: Int) {
        let pv = patternViews[patternViewIndex]
        dimView.frame = self.moireView.bounds
        dimView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.moireView.addSubview(dimView)
        highlightedViews.append(pv)
        self.moireView.bringSubviewToFront(pv)
    }
    
    func unhighlightPatternView(patternViewIndex: Int) {
        let pv = patternViews[patternViewIndex]
        if let i = highlightedViews.firstIndex(where: {$0 == pv}) {
            highlightedViews.remove(at: i)
        }
        if highlightedViews.count == 0 {
            dimView.removeFromSuperview()
        }
        self.sendSubviewToBack(pv)
    }
    
    func modifiyPatternView(patternViewIndex: Int, newPattern: Pattern) {
        self.patternViews[patternViewIndex].updatePattern(newPattern: newPattern)
    }
    
    func pauseMoire() {
        for pv in patternViews {
            pv.pauseAnimations()
        }
    }
    
    func resumeMoire() {
        for pv in patternViews {
            pv.resumeAnimations()
        }
    }
    
    func takeMoireScreenshot() -> UIImage? {
        for pv in patternViews {
            pv.mask?.backgroundColor = UIColor.black
        }
        UIGraphicsBeginImageContext(self.moireView.frame.size)
        guard let currentContext = UIGraphicsGetCurrentContext() else {return nil}
        self.moireView.layer.render(in: currentContext)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        for pv in patternViews {
            pv.mask?.backgroundColor = UIColor.clear
        }
        return img
    }
}
