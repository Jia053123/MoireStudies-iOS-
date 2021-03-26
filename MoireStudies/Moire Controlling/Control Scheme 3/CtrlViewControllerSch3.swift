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
    var id: Int!
    var delegate: PatternManager?
    
    required init(id: Int, frame: CGRect, pattern: Pattern?) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        let controlView: CtrlViewSch3Subclass = CtrlViewSch3Subclass.init(frame: frame)
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
        let cv = self.view as! CtrlViewSch3Subclass
        
        let boundResult = BoundsManager.calcBoundsForFillRatioAndScaleFactor(blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth)!
        cv.matchControlsWithBounds(fillRatioRange: boundResult.fillRatioRange, scaleFactorRange: boundResult.scaleFactorRange)
        
        let valueResult = Utilities.convertToFillRatioAndScaleFactor(blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth)
        cv.matchControlsWithValues(speed: pattern.speed, direction: pattern.direction, blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth, fillRatio: valueResult.fillRatio, scaleFactor: valueResult.scaleFactor)
    }
}
