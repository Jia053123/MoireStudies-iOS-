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
    weak var controlDelegate: ControlManager!
    let initPattern: Pattern?
    
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
}
