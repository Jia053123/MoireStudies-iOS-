//
//  MoireView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-17.
//

import UIKit
import Foundation

class MainView: UIView {
    typealias PatternViewClass = CoreAnimPatternView
    private var patternViews: Array<PatternView> = []
    private var maskViews: Array<MaskView> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.white
    }
    
    func setUpMoire(patterns: Array<Pattern>) {
        patternViews = []
        for pattern in patterns {
            let newPatternView: PatternView = PatternViewClass.init(frame: self.bounds)
            patternViews.append(newPatternView)
            self.addSubview(newPatternView)
            newPatternView.setUpAndRender(pattern: pattern)
        }
    }
    
    func modifiyPatternView(patternViewIndex: Int, newPattern: Pattern) {
        self.patternViews[patternViewIndex].updatePattern(newPattern: newPattern)
    }
    
    func setUpMaskOnPatternView(patternIndex: Int, controlViewFrame: CGRect) {
        let maskView = MaskView.init(frame: self.bounds, maskFrame: controlViewFrame)
        patternViews[patternIndex].mask = maskView
        print("added mask")
    }
}
