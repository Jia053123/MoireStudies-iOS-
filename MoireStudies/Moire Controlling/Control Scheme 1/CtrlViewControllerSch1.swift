//
//  ControlViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-31.
//

import Foundation
import UIKit

class CtrlViewControllerSch1: UIViewController, AbstractCtrlViewController {
    var _isHidden: Bool = false
    var isHidden: Bool {get {return _isHidden}}
    var id: String!
    weak var patternDelegate: PatternManager!
    weak var controlDelegate: ControlsManager!
    let initPattern: Pattern?
    private(set) var isInSelectionMode: Bool = false
    var isSelected: Bool {
        get { return (self.view as! SliderCtrlViewSch1).isSelected}
    }
    
    required init(id: String, frame: CGRect, pattern: Pattern?) {
        self.id = id
        self.initPattern = pattern
        super.init(nibName: nil, bundle: nil)
        let controlView: SliderCtrlViewSch1 = SliderCtrlViewSch1.init(frame: frame)
        self.view = controlView
        controlView.target = self
        if let p = pattern {
            self.matchControlsWithModel(pattern: p)
        }
    }
    
    required init?(coder: NSCoder) {
        self.initPattern = nil
        super.init(coder: coder)
    }

    func matchControlsWithModel(pattern: Pattern) {
        let cv = self.view as! SliderCtrlViewSch1
        let result = Utilities.convertToFillRatioAndScaleFactor(blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth)
        cv.matchControlsWithValues(speed: pattern.speed, direction: pattern.direction, fillRatio: result.fillRatio, scaleFactor: result.scaleFactor)
    }
    
    func enterSelectionMode() {
        let cv = self.view as! SliderCtrlViewSch1
        cv.enterSelectionMode()
        self.isInSelectionMode = true
    }
    
    func selectIfInSelectionMode() {
        if self.isInSelectionMode {
            (self.view as! SliderCtrlViewSch1).isSelected = true
            assert(self.isSelected)
        }
    }
    
    func exitSelectionMode() {
        let cv = self.view as! SliderCtrlViewSch1
        cv.exitSelectionMode()
        self.isInSelectionMode = false
    }
}

