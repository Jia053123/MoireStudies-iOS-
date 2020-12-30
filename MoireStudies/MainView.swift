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
    private var patternViews: Array<PatternViewSubclass> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.gray
    }
    
    func displayMoire(patterns: Array<Pattern>) {
        patternViews = []
        for pattern in patterns {
            let newPatternView: PatternViewSubclass = PatternViewSubclass.init(frame: self.bounds)
            patternViews.append(newPatternView)
            self.addSubview(newPatternView)
            newPatternView.setUp(pattern: pattern)
        }
    }
    
    func setUpMaskOnPatternView(patternView: UIView, controlFrame: CGRect) {
        // TODO: mask corresponding pattern view to match the control views
    }
}
