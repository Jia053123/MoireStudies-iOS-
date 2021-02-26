//
//  CtrlViewControllerSch3.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-24.
//

import Foundation
import UIKit

class CtrlViewControllerSch3: UIViewController {
    typealias CtrlViewSch3Subclass = SliderCtrlViewSch3
    var id: Int?
    var delegate: PatternManager?
    
    required init(id: Int, frame: CGRect, pattern: Pattern?) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        let controlView: ControlViewSch3 = CtrlViewSch3Subclass.init(frame: frame)
        self.view = controlView
        controlView.target = self
        if let p = pattern {
            self.matchControlsWithModel(pattern: p)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

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

extension CtrlViewControllerSch3: CtrlViewController {
    func matchControlsWithModel(pattern: Pattern) {
        let cv = self.view as! ControlViewSch3
        let result = Utilities.convertToFillRatioAndScaleFactor(blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth)
        cv.matchControlsWithValues(speed: pattern.speed, direction: pattern.direction, blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth, fillRatio: result.fillRatio, scaleFactor: result.scaleFactor)
    }
    
    func highlightPattern() {
        _ = delegate?.highlightPattern(caller: self)
    }
    
    func unhighlightPattern() {
        _ = delegate?.unhighlightPattern(caller: self)
    }
}
