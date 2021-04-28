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
    var patternDelegate: PatternManager! {get set}
    
    func matchControlsWithModel(pattern: Pattern) // TODO: make a pattern class with optionals to avoid setting the slider being controlled? 
}

extension BasicCtrlViewController {
    func highlightPattern() {
        _ = patternDelegate?.highlightPattern(callerId: self.id)
    }
    
    func unhighlightPattern() {
        _ = patternDelegate?.unhighlightPattern(callerId: self.id)
    }
    
    func dimPattern() {
        _ = patternDelegate?.dimPattern(callerId: self.id)
    }
    
    func undimPattern() {
        _ = patternDelegate?.undimPattern(callerId: self.id)
    }

    func hidePattern() -> Bool {
        return patternDelegate!.hidePattern(callerId: self.id)
    }
    
    func unhidePattern() {
        _ = patternDelegate?.unhidePattern(callerId: self.id)
    }
    
    func modifyPattern(speed: CGFloat) -> Bool {
        return patternDelegate?.modifyPattern(speed: speed, callerId: self.id) ?? false
    }
    
    func modifyPattern(direction: CGFloat) -> Bool {
        return patternDelegate?.modifyPattern(direction: direction, callerId: self.id) ?? false
    }
    
    func modifyPattern(blackWidth: CGFloat) -> Bool {
        guard let del = self.patternDelegate else {return false}
        let success = del.modifyPattern(blackWidth: blackWidth, callerId: self.id)
        if success {
            let newPattern = del.retrievePattern(callerId: self.id)!
            self.matchControlsWithModel(pattern: newPattern)
        }
        return success
    }
    
    func modifyPattern(whiteWidth: CGFloat) -> Bool {
        guard let del = self.patternDelegate else {return false}
        let success = del.modifyPattern(whiteWidth: whiteWidth, callerId: self.id)
        if success {
            let newPattern = del.retrievePattern(callerId: self.id)!
            self.matchControlsWithModel(pattern: newPattern)
        }
        return success
    }
    
    func modifyPattern(fillRatio: CGFloat) -> Bool {
        guard let del = self.patternDelegate else {return false}
        guard let p: Pattern = del.retrievePattern(callerId: self.id) else {return false}
        let sf = Utilities.convertToFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth).scaleFactor
        let result = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: fillRatio, scaleFactor: sf)
        let r1 = del.modifyPattern(blackWidth: result.blackWidth, callerId: self.id)
        let r2 = del.modifyPattern(whiteWidth: result.whiteWidth, callerId: self.id)
        
        let success = r1 && r2
        if success {
            let newPattern = del.retrievePattern(callerId: self.id)!
            self.matchControlsWithModel(pattern: newPattern)
        }
        return success
    }
    
    func modifyPattern(scaleFactor: CGFloat) -> Bool {
        guard let del = self.patternDelegate else {return false}
        guard let p: Pattern = del.retrievePattern(callerId: self.id) else {return false}
        let fr = Utilities.convertToFillRatioAndScaleFactor(blackWidth: p.blackWidth, whiteWidth: p.whiteWidth).fillRatio
        let result = Utilities.convertToBlackWidthAndWhiteWidth(fillRatio: fr, scaleFactor: scaleFactor)
        let r1 = del.modifyPattern(blackWidth: result.blackWidth, callerId: self.id)
        let r2 = del.modifyPattern(whiteWidth: result.whiteWidth, callerId: self.id)
        
        let success = r1 && r2
        if success {
            let newPattern = del.retrievePattern(callerId: self.id)!
            self.matchControlsWithModel(pattern: newPattern)
        }
        return success
    }
    
    func duplicatePattern() {
        guard let del = self.patternDelegate else {return}
        guard let newP: Pattern = del.retrievePattern(callerId: self.id) else {return}
        _ = del.createPattern(callerId: self.id, newPattern: newP)
    }
    
    func deletePattern() {
        _ = patternDelegate?.deletePattern(callerId: self.id)
    }
}
