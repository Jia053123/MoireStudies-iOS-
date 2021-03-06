//
//  CtrlViewControllerSch3.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-24.
//

import Foundation
import UIKit

protocol BasicCtrlViewController: CtrlViewController {
    var id: Int? {get set}
    var delegate: PatternManager? {get set}
    
    func matchControlsWithModel(pattern: Pattern) // TODO: make a pattern class with optionals to avoid setting the slider being controlled? 
}

extension BasicCtrlViewController {
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

    func hidePattern() -> Bool {
        return delegate!.hidePattern(caller: self)
    }
    
    func unhidePattern() {
        _ = delegate?.unhidePattern(caller: self)
    }
    
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
            self.matchControlsWithModel(pattern: newPattern)
        }
        return success
    }
    
    func modifyPattern(whiteWidth: CGFloat) -> Bool {
        guard let del = self.delegate else {return false}
        let success = del.modifyPattern(whiteWidth: whiteWidth, caller: self)
        if success {
            let newPattern = del.getPattern(caller: self)!
            self.matchControlsWithModel(pattern: newPattern)
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
            self.matchControlsWithModel(pattern: newPattern)
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
            self.matchControlsWithModel(pattern: newPattern)
        }
        return success
    }
    
    func duplicatePattern() {
        guard let del = self.delegate else {return}
        let newP: Pattern = del.getPattern(caller: self)!
        _ = del.createPattern(caller: self, newPattern: newP)
    }
    
    func deletePattern() {
        _ = delegate?.deletePattern(caller: self)
    }
}
