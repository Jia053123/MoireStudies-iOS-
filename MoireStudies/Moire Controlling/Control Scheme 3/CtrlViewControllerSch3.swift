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

extension CtrlViewControllerSch3: CtrlViewController {
    func matchControlsWithModel(pattern: Pattern) {
        let cv = self.view as! ControlViewSch3
        let result = Utilities.convertToFillRatioAndScaleFactor(blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth)
        cv.matchControlsWithValues(speed: pattern.speed, direction: pattern.direction, blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth, fillRatio: result.fillRatio, scaleFactor: result.scaleFactor)
    }
    
    func highlightPattern() {
        print("TODO: highlightPattern")
    }
    
    func unhighlightPattern() {
        print("TODO: unhighlightPattern")
    }
}
