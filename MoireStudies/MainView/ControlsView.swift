//
//  ControlsView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-18.
//

import Foundation
import UIKit

class ControlsView: UIView {
    private var controlViewControllers: Array<CtrlViewTarget> = []
    private var controlFrames: Array<CGRect> = Constants.UI.defaultControlFrames
    
    func setup(patterns: Array<Pattern>, settings: InitSettings, matcher: CtrlAndPatternMatcher, delegate: PatternManager) {
        self.reset(patterns: patterns, settings: settings, matcher: matcher, delegate: delegate)
    }
    
    func reset(patterns: Array<Pattern>, settings: InitSettings, matcher: CtrlAndPatternMatcher, delegate: PatternManager) {
        for sv in self.subviews {
            sv.removeFromSuperview() // TODO: reuse instead
        }
        for cvc in self.controlViewControllers {
            cvc.view.removeFromSuperview()
        }
        self.controlViewControllers = []
        assert(controlFrames.count >= patterns.count)
        for i in 0..<patterns.count {
            var cvc: CtrlViewTarget?
            let id = matcher.getCtrlViewControllerId(indexOfPatternControlled: i)
            switch settings.interfaceSetting {
            case UISettings.controlScheme1Slider:
                cvc = CtrlViewControllerSch1.init(id: id, frame: controlFrames[i], pattern: patterns[i])
            case UISettings.controlScheme2Slider:
                cvc = CtrlViewControllerSch2.init(id: id, frame: controlFrames[i], pattern: patterns[i])
            case UISettings.controlScheme1Gesture:
                cvc = CtrlViewControllerSch1.init(id: id, frame: controlFrames[i], pattern: patterns[i])
            }
            cvc!.delegate = delegate
            self.addSubview(cvc!.view)
            self.controlViewControllers.append(cvc!)
        }
    }
    
    private func getCtrlViewControllerId(index: Int) -> Int {
        let id = index
        assert(self.getCtrlViewControllerIndex(id: id) == index, "reverse conversion test failed")
        return id
    }
    
    private func getCtrlViewControllerIndex(id: Int) -> Int {
        let index = id
        return index
    }
    
    private func findControlViewIndex(controlViewController: CtrlViewTarget) -> Int? {
        guard let i = controlViewController.id else {
            return nil
        }
        return self.getCtrlViewControllerIndex(id: i)
    }
}
