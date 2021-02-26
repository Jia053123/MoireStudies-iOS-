//
//  ControlViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-31.
//

import Foundation
import UIKit

class CtrlViewControllerSch1: UIViewController { // TODO: remove this class and use the scheme3 controller? 
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
}

extension CtrlViewControllerSch1 {
    // these functions return false when the action is illegal, otherwise they return true and the action is performed
    func modifyPattern(speed: CGFloat) -> Bool {
        return delegate?.modifyPattern(speed: speed, caller: self) ?? false
    }
    
    func modifyPattern(direction: CGFloat) -> Bool {
        return delegate?.modifyPattern(direction: direction, caller: self) ?? false
    }
    
    func modifyPattern(fillRatio: CGFloat) -> Bool {
        guard let d = self.delegate else {return false}
        
        let p: Pattern = d.getPattern(caller: self)!
        let sf = Utilities.convertToFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth).scaleFactor
        let result = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: fillRatio, scaleFactor: sf)
        let r1 = d.modifyPattern(blackWidth: result.blackWidth, caller: self)
        let r2 = d.modifyPattern(whiteWidth: result.whiteWidth, caller: self)
        return r1 && r2
    }
    
    func modifyPattern(scaleFactor: CGFloat) -> Bool {
        guard let d = self.delegate else {return false}
        
        let p: Pattern = d.getPattern(caller: self)!
        let fr = Utilities.convertToFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth).fillRatio
        let result = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: fr, scaleFactor: scaleFactor)
        let r1 = d.modifyPattern(blackWidth: result.blackWidth, caller: self)
        let r2 = d.modifyPattern(whiteWidth: result.whiteWidth, caller: self)
        return r1 && r2
    }
}

extension CtrlViewControllerSch1: CtrlViewController {
    func highlightPattern() {
        _ = delegate?.highlightPattern(caller: self)
    }
    
    func unhighlightPattern() {
        _ = delegate?.unhighlightPattern(caller: self)
    }
    
    func matchControlsWithModel(pattern: Pattern) {
        let cv = self.view as! ControlViewSch1
        let result = Utilities.convertToFillRatioAndScaleFactor(blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth)
        cv.matchControlsWithValues(speed: pattern.speed,
                                   direction: pattern.direction,
                                   fillRatio: result.fillRatio,
                                   scaleFactor: result.scaleFactor)
    }
}

