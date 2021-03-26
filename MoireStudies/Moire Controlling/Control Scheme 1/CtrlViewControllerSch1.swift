//
//  ControlViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-31.
//

import Foundation
import UIKit

class CtrlViewControllerSch1: UIViewController, BasicCtrlViewController {
    var _isHidden: Bool = false
    var isHidden: Bool {get {return _isHidden}}
    var id: Int!
    var delegate: PatternManager?
    
    required init(id: Int, frame: CGRect, pattern: Pattern?) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        let controlView: SliderCtrlViewSch1 = SliderCtrlViewSch1.init(frame: frame)
        self.view = controlView
        controlView.target = self
        if let p = pattern {
            self.matchControlsWithModel(pattern: p)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func matchControlsWithModel(pattern: Pattern) {
        let cv = self.view as! SliderCtrlViewSch1
        let result = Utilities.convertToFillRatioAndScaleFactor(blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth)
        cv.matchControlsWithValues(speed: pattern.speed, direction: pattern.direction, fillRatio: result.fillRatio, scaleFactor: result.scaleFactor)
    }
}

