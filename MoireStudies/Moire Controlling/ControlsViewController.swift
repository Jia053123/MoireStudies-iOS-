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
    
    func setUp(patterns: Array<Pattern>, settings: InitSettings, matcher: CtrlAndPatternMatcher, delegate: PatternManager) {
        self.reset(patterns: patterns, settings: settings, matcher: matcher, delegate: delegate)
    }
    
    func reset(patterns: Array<Pattern>, settings: InitSettings, matcher: CtrlAndPatternMatcher, delegate: PatternManager) {
        for c in self.children {
            c.willMove(toParent: nil)
            c.view.removeFromSuperview()
            c.removeFromParent()  // TODO: reuse?
        }
        let controlFrames = settings.controlFrames
        assert(controlFrames.count >= patterns.count)
        for i in 0..<patterns.count {
            var cvc: CtrlViewController
            let id = matcher.getCtrlViewControllerId(indexOfPatternControlled: i)
            switch settings.interfaceSetting {
            case UISettings.controlScheme1Slider:
                cvc = CtrlViewControllerSch1.init(id: id, frame: controlFrames[i], pattern: patterns[i])
            case UISettings.controlScheme2Slider:
                cvc = CtrlViewControllerSch2.init(id: id, frame: controlFrames[i], pattern: patterns[i])
            case UISettings.controlScheme1Gesture:
                cvc = CtrlViewControllerSch1.init(id: id, frame: controlFrames[i], pattern: patterns[i])
            case UISettings.controlScheme3Slider:
                cvc = CtrlViewControllerSch3.init(id: id, frame: controlFrames[i], pattern: patterns[i])
            }
            cvc.delegate = delegate
            self.addChild(cvc)
            self.view.addSubview(cvc.view)
            cvc.didMove(toParent: self)
        }
    }
}
