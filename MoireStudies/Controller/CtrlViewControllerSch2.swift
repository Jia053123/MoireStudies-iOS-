//
//  CtrlViewControllerSch2.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-03.
//

import Foundation
import UIKit

class CtrlViewControllerSch2: UIViewController, CtrlViewController, CtrlSch2Target {
    typealias CtrlViewSch2Subclass = SliderCtrlViewSch2
    var id: Int?
    weak var delegate: PatternManager?
    
    required init(id: Int, frame: CGRect, pattern: Pattern?) {
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
    
    func highlightPattern() {
        _ = delegate?.highlightPattern(caller: self)
    }
    
    func unhighlightPattern() {
        _ = delegate?.unhighlightPattern(caller: self)
    }
    
    func convertToFillRatioAndScaleFactor(blackWidth: CGFloat, whiteWidth: CGFloat) -> (fillRatio: CGFloat, scaleFactor: CGFloat) {
        let fr: CGFloat = blackWidth / (blackWidth + whiteWidth)
        let sf: CGFloat = blackWidth / (fr * Constants.UI.tileHeight)
        return (fr, sf)
    }
    
    func convertToBlackWidthAndWhiteWidth(fillRatio: CGFloat, scaleFactor: CGFloat) -> (blackWidth: CGFloat, whiteWidth: CGFloat) {
        let bw: CGFloat = fillRatio * Constants.UI.tileHeight * scaleFactor
        let ww: CGFloat = (1-fillRatio) * Constants.UI.tileHeight * scaleFactor
        return (bw, ww)
    }
    
    func modifyPattern(speed: CGFloat) -> Bool {
        return delegate?.modifyPattern(speed: speed, caller: self) ?? false
    }
    
    func modifyPattern(direction: CGFloat) -> Bool {
        return delegate?.modifyPattern(direction: direction, caller: self) ?? false
    }
    
    func modifyPattern(blackWidth: CGFloat) -> Bool {
        print("setting blackWidth to: ", blackWidth)
        guard let d = self.delegate else {
            return false
        }
        let p: Pattern = d.getPattern(caller: self)!
        let ww = convertToBlackWidthAndWhiteWidth(fillRatio: p.fillRatio, scaleFactor: p.scaleFactor).whiteWidth
        let result = convertToFillRatioAndScaleFactor(blackWidth: blackWidth, whiteWidth: ww)
        let r1 = d.modifyPattern(fillRatio: result.fillRatio, caller: self)
        let r2 = d.modifyPattern(scaleFactor: result.scaleFactor, caller: self)
        return r1 && r2
    }
    
    func modifyPattern(whiteWidth: CGFloat) -> Bool {
        print("setting whiteWidth to: ", whiteWidth)
        guard let d = self.delegate else {
            return false
        }
        let p: Pattern = d.getPattern(caller: self)!
        let bw = convertToBlackWidthAndWhiteWidth(fillRatio: p.fillRatio, scaleFactor: p.scaleFactor).blackWidth
        let result = convertToFillRatioAndScaleFactor(blackWidth: bw, whiteWidth: whiteWidth)
        let r1 = d.modifyPattern(fillRatio: result.fillRatio, caller: self)
        let r2 = d.modifyPattern(scaleFactor: result.scaleFactor, caller: self)
        return r1 && r2
    }
    
    func matchControlsWithModel(pattern: Pattern) {
        let cv = self.view as! ControlViewSch2
        let result = self.convertToBlackWidthAndWhiteWidth(fillRatio: pattern.fillRatio,
                                                           scaleFactor: pattern.scaleFactor)
        cv.matchControlsWithValues(speed: pattern.speed,
                                   direction: pattern.direction,
                                   blackWidth: result.blackWidth,
                                   whiteWidth: result.whiteWidth)
    }
}

