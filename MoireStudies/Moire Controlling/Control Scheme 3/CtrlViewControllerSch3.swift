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
}

extension CtrlViewControllerSch3 {
    // these functions return false when the action is illegal, otherwise they return true and the action is performed
    func modifyPattern(speed: CGFloat) -> Bool {
        return delegate?.modifyPattern(speed: speed, caller: self) ?? false
    }
    
    func modifyPattern(direction: CGFloat) -> Bool {
        return delegate?.modifyPattern(direction: direction, caller: self) ?? false
    }
    
    func modifyPattern(blackWidth: CGFloat) -> Bool {
        guard let del = self.delegate else {return false}
        let success = del.modifyPattern(blackWidth: blackWidth, caller: self)
        if success {
            let newPattern = del.getPattern(caller: self)!
            let cv = self.view as! ControlViewSch3
            let result = Utilities.convertToFillRatioAndScaleFactor(blackWidth: newPattern.blackWidth, whiteWidth: newPattern.whiteWidth)
            
            cv.matchControlsWithValues(speed: newPattern.speed, direction: newPattern.direction, blackWidth: nil, whiteWidth: newPattern.whiteWidth, fillRatio: result.fillRatio, scaleFactor: result.scaleFactor)
        }
        return success
    }
    
    func modifyPattern(whiteWidth: CGFloat) -> Bool {
        guard let del = self.delegate else {return false}
        let success = del.modifyPattern(whiteWidth: whiteWidth, caller: self)
        if success {
            let newPattern = del.getPattern(caller: self)!
            let cv = self.view as! ControlViewSch3
            let result = Utilities.convertToFillRatioAndScaleFactor(blackWidth: newPattern.blackWidth, whiteWidth: newPattern.whiteWidth)
            
            cv.matchControlsWithValues(speed: newPattern.speed, direction: newPattern.direction, blackWidth: newPattern.blackWidth, whiteWidth: nil, fillRatio: result.fillRatio, scaleFactor: result.scaleFactor)
        }
        return success
    }
    
    func modifyPattern(fillRatio: CGFloat) -> Bool {
        guard let del = self.delegate else {return false}
        let p: Pattern = del.getPattern(caller: self)!
        let sf = Utilities.convertToFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth).scaleFactor
        let result = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: fillRatio, scaleFactor: sf)
        let r1 = del.modifyPattern(blackWidth: result.blackWidth, caller: self)
        let r2 = del.modifyPattern(whiteWidth: result.whiteWidth, caller: self)
        
        let success = r1 && r2
        if success {
            let newPattern = del.getPattern(caller: self)!
            let cv = self.view as! ControlViewSch3
            let result = Utilities.convertToFillRatioAndScaleFactor(blackWidth: newPattern.blackWidth, whiteWidth: newPattern.whiteWidth)
            
            cv.matchControlsWithValues(speed: newPattern.speed, direction: newPattern.direction, blackWidth: newPattern.blackWidth, whiteWidth: newPattern.whiteWidth, fillRatio: nil, scaleFactor: result.scaleFactor)
        }
        return success
    }
    
    func modifyPattern(scaleFactor: CGFloat) -> Bool {
        guard let del = self.delegate else {return false}
        let p: Pattern = del.getPattern(caller: self)!
        let fr = Utilities.convertToFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth).fillRatio
        let result = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: fr, scaleFactor: scaleFactor)
        let r1 = del.modifyPattern(blackWidth: result.blackWidth, caller: self)
        let r2 = del.modifyPattern(whiteWidth: result.whiteWidth, caller: self)
        
        let success = r1 && r2
        if success {
            let newPattern = del.getPattern(caller: self)!
            let cv = self.view as! ControlViewSch3
            let result = Utilities.convertToFillRatioAndScaleFactor(blackWidth: newPattern.blackWidth, whiteWidth: newPattern.whiteWidth)
            
            cv.matchControlsWithValues(speed: newPattern.speed, direction: newPattern.direction, blackWidth: newPattern.blackWidth, whiteWidth: newPattern.whiteWidth, fillRatio: result.fillRatio, scaleFactor: nil)
        }
        return success
    }
}

extension CtrlViewControllerSch3 {
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
}

extension CtrlViewControllerSch3 {
    func duplicatePattern() {
        guard let del = self.delegate else {return}
        let newP: Pattern = del.getPattern(caller: self)!
        _ = del.createPattern(caller: self, newPattern: newP)
    }
    
    func deletePattern() {
        _ = delegate?.deletePattern(caller: self)
    }
}

extension CtrlViewControllerSch3: CtrlViewController {
    func matchControlsWithModel(pattern: Pattern) {
        let cv = self.view as! ControlViewSch3
        let result = Utilities.convertToFillRatioAndScaleFactor(blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth)
        cv.matchControlsWithValues(speed: pattern.speed, direction: pattern.direction, blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth, fillRatio: result.fillRatio, scaleFactor: result.scaleFactor)
    }
}
