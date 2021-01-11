//
//  MoireView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-17.
//

import UIKit
import Foundation

class MainView: UIView {
    @IBOutlet weak var gearButton: UIButton!
    typealias PatternViewClass = CoreAnimPatternView
    private var patternViews: Array<PatternView> = []
    private var maskViews: Array<MaskView> = []
    
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
    }
    
    func setUp(patterns: Array<Pattern>) {
        patternViews = []
        for pattern in patterns {
            let newPatternView: PatternView = PatternViewClass.init(frame: self.bounds)
            patternViews.append(newPatternView)
            self.addSubview(newPatternView)
            newPatternView.setUpAndRender(pattern: pattern)
        }
        self.bringSubviewToFront(gearButton)
    }
    
    func highlightPatternView(patternViewIndex: Int) {
        print("highlight")
        // TODO
    }
    
    func unhighlightPatternView(patternViewIndex: Int) {
        print("unhighlight")
        // TODO
    }
    
    func modifiyPatternView(patternViewIndex: Int, newPattern: Pattern) {
        self.patternViews[patternViewIndex].updatePattern(newPattern: newPattern)
    }
    
    func setUpMaskOnPatternView(patternIndex: Int, controlViewFrame: CGRect) {
        let maskView = MaskView.init(frame: self.bounds, maskFrame: controlViewFrame)
        patternViews[patternIndex].mask = maskView
    }
}
