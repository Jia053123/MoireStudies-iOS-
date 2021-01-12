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
    - ControlView (n)
    - MoireView (1)
        - DimView (0..1)
        - PatternView (n)
            - MaskView(1) in mask property
 */
class MainView: UIView {
    @IBOutlet weak var gearButton: UIButton!
    @IBOutlet weak var fileButton: UIButton!
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
        self.moireView.frame = self.bounds
        patternViews = []
        for pattern in patterns {
            let newPatternView: PatternView = PatternViewClass.init(frame: self.moireView.bounds)
            patternViews.append(newPatternView)
            self.moireView.addSubview(newPatternView)
            newPatternView.setUpAndRender(pattern: pattern)
        }
        self.bringSubviewToFront(gearButton)
        self.bringSubviewToFront(fileButton)
    }
    
    func highlightPatternView(patternViewIndex: Int) {
        print("highlight")
        let pv = patternViews[patternViewIndex]
        dimView.frame = self.moireView.bounds
        dimView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.moireView.addSubview(dimView)
        highlightedViews.append(pv)
        self.moireView.bringSubviewToFront(pv)
    }
    
    func unhighlightPatternView(patternViewIndex: Int) {
        print("unhighlight")
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
    
    func setUpMaskOnPatternView(patternIndex: Int, controlViewFrame: CGRect) {
        let maskView = MaskView.init(frame: self.moireView.bounds, maskFrame: controlViewFrame)
        patternViews[patternIndex].mask = maskView
    }
}
