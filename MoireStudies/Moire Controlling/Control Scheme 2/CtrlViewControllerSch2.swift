//
//  CtrlViewControllerSch2.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-03.
//

import Foundation
import UIKit

class CtrlViewControllerSch2: UIViewController, BasicCtrlViewController {
    var id: String!
    weak var patternDelegate: PatternManager!
    weak var controlDelegate: ControlManager!
    let initPattern: Pattern?
    
    required init(id: String, frame: CGRect, pattern: Pattern?) {
        self.id = id
        self.initPattern = pattern
        super.init(nibName: nil, bundle: nil)
        let controlView: SliderCtrlViewSch2 = SliderCtrlViewSch2.init(frame: frame)
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
        let cv = self.view as! SliderCtrlViewSch2
        cv.matchControlsWithValues(speed: pattern.speed, direction: pattern.direction, blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth)
    }
    
    func enterSelectionMode() {
        // TODO: stub
    }
    
    func exitSelectionMode() {
        // TODO: stub
    }
}
