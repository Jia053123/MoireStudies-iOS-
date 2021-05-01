//
//  CtrlViewControllerSch3.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-24.
//

import Foundation
import UIKit

class CtrlViewControllerSch3: UIViewController, BasicCtrlViewController {
    typealias CtrlViewSch3Subclass = SliderCtrlViewSch3
    var id: String!
    weak var patternDelegate: PatternManager!
    weak var controlDelegate: ControlsManager!
    let initPattern: Pattern?
    private(set) var isInSelectionMode: Bool = false
    var isSelected: Bool {
        get { return (self.view as! SliderCtrlViewSch3).isSelected}
    }
    
    required init(id: String, frame: CGRect, pattern: Pattern?) {
        self.id = id
        self.initPattern = pattern
        super.init(nibName: nil, bundle: nil)
        let controlView: CtrlViewSch3Subclass = CtrlViewSch3Subclass.init(frame: frame)
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
        let cv = self.view as! CtrlViewSch3Subclass
        
        guard let boundResult = BoundsManager.calcBoundsForFillRatioAndScaleFactor(blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth) else {return}
        cv.matchControlsWithBounds(fillRatioRange: boundResult.fillRatioRange, scaleFactorRange: boundResult.scaleFactorRange)
        
        let valueResult = Utilities.convertToFillRatioAndScaleFactor(blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth)
        cv.matchControlsWithValues(speed: pattern.speed, direction: pattern.direction, blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth, fillRatio: valueResult.fillRatio, scaleFactor: valueResult.scaleFactor)
    }
    
    func enterSelectionMode() {
        let cv = self.view as! CtrlViewSch3Subclass
        cv.enterSelectionMode()
        self.isInSelectionMode = true
    }
    
    func selectIfInSelectionMode() {
        if self.isInSelectionMode {
            (self.view as! CtrlViewSch3Subclass).isSelected = true
            assert(self.isSelected)
        }
    }
    
    func exitSelectionMode() {
        let cv = self.view as! CtrlViewSch3Subclass
        cv.exitSelectionMode()
        self.isInSelectionMode = false
    }
}
