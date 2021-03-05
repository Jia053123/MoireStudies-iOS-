//
//  CtrlViewControllerSch2.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-03.
//

import Foundation
import UIKit

class CtrlViewControllerSch2: UIViewController { // TODO: remove this class and use the scheme3 controller? 
    typealias CtrlViewSch2Subclass = SliderCtrlViewSch2
    var id: String?
    weak var delegate: PatternManager?
    
    required init(id: String, frame: CGRect, pattern: Pattern?) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        let controlView: ControlViewSch2 = CtrlViewSch2Subclass.init(frame: frame)
        self.view = controlView
        controlView.target = self
        if let p = pattern {
            self.matchControlsWithModel(pattern: p)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension CtrlViewControllerSch2 {
    // these functions return false when the action is illegal, otherwise they return true and the action is performed
    func modifyPattern(speed: CGFloat) -> Bool {
        return delegate?.modifyPattern(speed: speed, caller: self) ?? false
    }
    
    func modifyPattern(direction: CGFloat) -> Bool {
        return delegate?.modifyPattern(direction: direction, caller: self) ?? false
    }
    
    func modifyPattern(blackWidth: CGFloat) -> Bool {
        return delegate?.modifyPattern(blackWidth: blackWidth, caller: self) ?? false
    }
    
    func modifyPattern(whiteWidth: CGFloat) -> Bool {
        return delegate?.modifyPattern(whiteWidth: whiteWidth, caller: self) ?? false
    }
}

extension CtrlViewControllerSch2: CtrlViewController {
    func highlightPattern() {
        _ = delegate?.highlightPattern(caller: self)
    }
    
    func unhighlightPattern() {
        _ = delegate?.unhighlightPattern(caller: self)
    }
    
    func dimPattern() {
        _ = delegate?.dimPattern(caller: self)
    }
    
    func undimPattern() {
        _ = delegate?.undimPattern(caller: self)
    }
    
    func matchControlsWithModel(pattern: Pattern) {
        let cv = self.view as! ControlViewSch2
        cv.matchControlsWithValues(speed: pattern.speed, direction: pattern.direction, blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth)
    }
}

