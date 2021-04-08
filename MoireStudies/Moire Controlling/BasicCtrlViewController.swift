//
//  CtrlViewControllerSch3.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-24.
//

import Foundation
import UIKit

protocol BasicCtrlViewController: CtrlViewController {
    var id: String! {get set}
    var delegate: PatternManager? {get set}
    
    func matchControlsWithModel(pattern: Pattern) // TODO: make a pattern class with optionals to avoid setting the slider being controlled? 
}

extension BasicCtrlViewController {
    func highlightPattern() {
        _ = delegate?.highlightPattern(callerId: self.id)
    }
    
    func unhighlightPattern() {
        _ = delegate?.unhighlightPattern(callerId: self.id)
    }
    
    func dimPattern() {
        _ = delegate?.dimPattern(callerId: self.id)
    }
    
    func undimPattern() {
        _ = delegate?.undimPattern(callerId: self.id)
    }

    func hidePattern() -> Bool {
        return delegate!.hidePattern(callerId: self.id)
    }
    
    func unhidePattern() {
        _ = delegate?.unhidePattern(callerId: self.id)
    }
    
    func modifyPattern(speed: CGFloat) -> Bool {
        return delegate?.modifyPattern(speed: speed, callerId: self.id) ?? false
    }
    
    func modifyPattern(direction: CGFloat) -> Bool {
        return delegate?.modifyPattern(direction: direction, callerId: self.id) ?? false
    }
    
    func modifyPattern(blackWidth: CGFloat) -> Bool {
        guard let del = self.delegate else {return false}
        let success = del.modifyPattern(blackWidth: blackWidth, callerId: self.id)
        if success {
            let newPattern = del.getPattern(callerId: self.id)!
            self.matchControlsWithModel(pattern: newPattern)
        }
        return success
    }
    
    func modifyPattern(whiteWidth: CGFloat) -> Bool {
        guard let del = self.delegate else {return false}
        let success = del.modifyPattern(whiteWidth: whiteWidth, callerId: self.id)
        if success {
            let newPattern = del.getPattern(callerId: self.id)!
            self.matchControlsWithModel(pattern: newPattern)
        }
        return success
    }
    
    func modifyPattern(fillRatio: CGFloat) -> Bool {
        guard let del = self.delegate else {return false}
        guard let p: Pattern = del.getPattern(callerId: self.id) else {return false}
        let sf = Utilities.convertToFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth).scaleFactor
        let result = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: fillRatio, scaleFactor: sf)
        let r1 = del.modifyPattern(blackWidth: result.blackWidth, callerId: self.id)
        let r2 = del.modifyPattern(whiteWidth: result.whiteWidth, callerId: self.id)
        
        let success = r1 && r2
        if success {
            let newPattern = del.getPattern(callerId: self.id)!
            self.matchControlsWithModel(pattern: newPattern)
        }
        return success
    }
    
    func modifyPattern(scaleFactor: CGFloat) -> Bool {
        guard let del = self.delegate else {return false}
        guard let p: Pattern = del.getPattern(callerId: self.id) else {return false}
        let fr = Utilities.convertToFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth).fillRatio
        let result = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: fr, scaleFactor: scaleFactor)
        let r1 = del.modifyPattern(blackWidth: result.blackWidth, callerId: self.id)
        let r2 = del.modifyPattern(whiteWidth: result.whiteWidth, callerId: self.id)
        
        let success = r1 && r2
        if success {
            let newPattern = del.getPattern(callerId: self.id)!
            self.matchControlsWithModel(pattern: newPattern)
        }
        return success
    }
    
    func duplicatePattern() {
        guard let del = self.delegate else {return}
        guard let newP: Pattern = del.getPattern(callerId: self.id) else {return}
        _ = del.createPattern(callerId: self.id, newPattern: newP)
    }
    
    func deletePattern() {
        _ = delegate?.deletePattern(callerId: self.id)
    }
}
