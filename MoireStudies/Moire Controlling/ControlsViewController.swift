//
//  ControlsViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-08.
//

import Foundation
import UIKit

class ControlsViewController: UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
    }
    
    func setUp(patterns: Array<Pattern>, configs: Configurations, ids: Array<String>, delegate: PatternManager) {
        self.reset(patterns: patterns, configs: configs, ids: ids, delegate: delegate)
    }

    func reset(patterns: Array<Pattern>, configs: Configurations, ids: Array<String>, delegate: PatternManager) {
        for c in self.children {
            c.willMove(toParent: nil)
            c.view.removeFromSuperview()
            c.removeFromParent()  // TODO: reuse?
        }
        let controlFrames = configs.controlFrames
        assert(controlFrames.count >= ids.count)
        for i in 0..<ids.count {
            var cvc: CtrlViewController
            let id = ids[i]
            let pattern = patterns.count > i ? patterns[i] : nil
            switch configs.ctrlSchemeSetting {
            case CtrlSchemeSetting.controlScheme1Slider:
                cvc = CtrlViewControllerSch1.init(id: id, frame: controlFrames[i], pattern: pattern)
            case CtrlSchemeSetting.controlScheme2Slider:
                cvc = CtrlViewControllerSch2.init(id: id, frame: controlFrames[i], pattern: pattern)
            case CtrlSchemeSetting.controlScheme1Gesture:
                cvc = CtrlViewControllerSch1.init(id: id, frame: controlFrames[i], pattern: pattern)
            case CtrlSchemeSetting.controlScheme3Slider:
                cvc = CtrlViewControllerSch3.init(id: id, frame: controlFrames[i], pattern: pattern)
            }
            cvc.delegate = delegate
            self.addChild(cvc)
            self.view.addSubview(cvc.view)
            cvc.didMove(toParent: self)
        }
        // stub code for the high degree controls
//        let hdcvc = HighDegreeCtrlViewController.init(id: "01234", frame: Constants.UI.highDegreeControlFrame, patterns: patterns)
//        hdcvc.delegate = delegate
//        self.addChild(hdcvc)
//        self.view.addSubview(hdcvc.view)
//        hdcvc.didMove(toParent: self)
    }
}
