//
//  MoireView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-17.
//

import UIKit
import Foundation

class MainView: UIView {
    typealias PatternViewSubclass = CoreAnimPatternView
    typealias ControlViewSubclass = SliderControlView
    
    var controlFrame1 = CGRect(x: 10, y: 30, width: 150, height: 300)
    var controlView1: ControlView?
    
    private var patternViews: Array<PatternViewSubclass> = []
    private var controlViews: Array<ControlViewSubclass> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func displayMoire(patterns: Array<Pattern>) {
        patternViews = []
        for pattern in patterns {
            let newPatternView: PatternViewSubclass = PatternViewSubclass.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            patternViews.append(newPatternView)
            self.addSubview(newPatternView)
            newPatternView.setUp(pattern: pattern)
        }
        self.setUpControls(frame: controlFrame1)
    }
    
    func setUpMaskOnPatternView(patternView: UIView, controlFrame: CGRect) {
        // TODO: mask corresponding pattern view to match the control views
    }
    
    func setUpControls(frame: CGRect) {
        controlView1 = ControlViewSubclass.init(frame: frame)
        if let cv = controlView1 {
            self.addSubview(cv)
        }
    }
}
