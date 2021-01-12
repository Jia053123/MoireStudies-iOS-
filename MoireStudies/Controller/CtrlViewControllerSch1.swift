//
//  ControlViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-31.
//

import Foundation
import UIKit

class CtrlViewControllerSch1: UIViewController, CtrlViewSch1Target {
    typealias CtrlViewSch1Subclass = SliderCtrlViewSch1
    var id: Int?
    weak var delegate: PatternManager?
    
    required init(id: Int, frame: CGRect, pattern: Pattern?) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        let controlView: ControlViewSch1 = CtrlViewSch1Subclass.init(frame: frame)
        self.view = controlView
        controlView.target = self
        if let p = pattern {
            self.matchControlsWithModel(pattern: p)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func highlightPattern() {
        _ = delegate?.highlightPattern(caller: self)
    }
    
    func unhighlightPattern() {
        _ = delegate?.unhighlightPattern(caller: self)
    }
    
    func modifyPattern(speed: CGFloat) -> Bool {
        return delegate?.modifyPattern(speed: speed, caller: self) ?? false
    }
    
    func modifyPattern(direction: CGFloat) -> Bool {
        return delegate?.modifyPattern(direction: direction, caller: self) ?? false
    }
    
    func modifyPattern(fillRatio: CGFloat) -> Bool {
        return delegate?.modifyPattern(fillRatio: fillRatio, caller: self) ?? false
    }
    
    func modifyPattern(scaleFactor: CGFloat) -> Bool {
        return delegate?.modifyPattern(scaleFactor: scaleFactor, caller: self) ?? false
    }
    
    func matchControlsWithModel(pattern: Pattern) {
        let cv = self.view as! ControlViewSch1
        cv.matchControlsWithModel(pattern: pattern)
    }
}

