//
//  MoireView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-17.
//

import UIKit
import Foundation

class MoireView: UIView {
    typealias PatternViewSubclass = CoreAnimPatternView
    typealias ControlViewSubclass = SliderControlView
    
    var controlFrame1 = CGRect(x: 10, y: 30, width: 200, height: 300)
    var patternView1: PatternView?
    var controlView1: ControlView?
    var patternView2: PatternView?
    var controlView2: ControlView?
    
    @objc func setUp() {
        let diagonalLength = Double(sqrt(pow(Float(self.frame.width), 2) + pow(Float(self.frame.height), 2)))
        patternView1 = PatternViewSubclass.init(frame: CGRect(x: 0, y: 0, width: diagonalLength, height: diagonalLength))
        patternView1?.center = CGPoint(x: self.frame.width/2.0, y: self.frame.height/2.0)
        patternView1?.setUp()
        if let pv = patternView1 {
            self.addSubview(pv)
        }
        // TODO: setup patternView2
        //self.setUpMaskOnPatternView(patternView: patternView2, controlFrame: controlFrame1)
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
