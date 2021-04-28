//
//  ControlsViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-08.
//

import Foundation
import UIKit

class ControlsViewController: UIViewController {
    private var controlViewControllers: Array<CtrlViewController>!
    private var highDegControlViewControllers: Array<HighDegCtrlViewController>!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
    }
    
    func setUp(patterns: Array<Pattern>, configs: Configurations, ids: Array<String>, highDegIds: Array<String>, delegate: PatternManager) {
        self.reset(patterns: patterns, configs: configs, ids: ids, highDegIds: highDegIds, delegate: delegate)
    }

    func reset(patterns: Array<Pattern>, configs: Configurations, ids: Array<String>, highDegIds: Array<String>, delegate: PatternManager) {
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
            let p = Utilities.tryAccessArray(array: patterns, index: i)
            switch configs.ctrlSchemeSetting {
            case CtrlSchemeSetting.controlScheme1Slider:
                cvc = CtrlViewControllerSch1.init(id: id, frame: controlFrames[i], pattern: p)
            case CtrlSchemeSetting.controlScheme2Slider:
                cvc = CtrlViewControllerSch2.init(id: id, frame: controlFrames[i], pattern: p)
            case CtrlSchemeSetting.controlScheme1Gesture:
                cvc = CtrlViewControllerSch1.init(id: id, frame: controlFrames[i], pattern: p)
            case CtrlSchemeSetting.controlScheme3Slider:
                cvc = CtrlViewControllerSch3.init(id: id, frame: controlFrames[i], pattern: p)
            }
            cvc.patternDelegate = delegate
            self.addChild(cvc)
            self.view.addSubview(cvc.view)
            cvc.didMove(toParent: self)
        }
        
        let hdControlFrames = configs.highDegControlFrames
        assert(hdControlFrames.count >= highDegIds.count)
        for i in 0..<highDegIds.count {
            var hdcvc: HighDegCtrlViewController
            let id = highDegIds[i]
            let hds = configs.highDegreeControlSettings[i]
            let ps = hds.indexesOfPatternControlled.map({Utilities.tryAccessArray(array: patterns, index: $0)})
            
            switch hds.highDegCtrlSchemeSetting {
            case .basicScheme:
                hdcvc = HighDegCtrlViewControllerBasic.init(id: id, frame: hdControlFrames[i], patterns: ps)
            }
            hdcvc.delegate = delegate
            self.addChild(hdcvc)
            self.view.addSubview(hdcvc.view)
            hdcvc.didMove(toParent: self)
        }
        
        self.controlViewControllers = Array(self.children.dropLast(highDegIds.count)) as? [CtrlViewController]
        self.highDegControlViewControllers = Array(self.children.dropFirst(ids.count)) as? [HighDegCtrlViewController]
    }
    
    func enterSelectionMode() {
        for c in self.controlViewControllers {
            if !c.isInSelectionMode {
                c.enterSelectionMode()
            }
        }
    }
    
    func exitSelectionMode() {
        for c in self.controlViewControllers {
            if c.isInSelectionMode {
                c.exitSelectionMode()
            }
        }
    }
}

extension ControlsViewController: ControlManager {
    
}
