//
//  ControlsViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-08.
//

import Foundation
import UIKit

/// Structure of self.children: CtrlViewController instances + HighDegCtrlViewController instances + other children
/// Invariable: the order of CtrlViewController instances is the same as that of patterns parameter in setUp and reset methods
class ControlsViewController: UIViewController, PatternsSelector {
    private var controlViewControllers: Array<CtrlViewController>!
    private var highDegControlViewControllers: Array<HighDegCtrlViewController>!
    private var configurations: Configurations!
    var selectedPatternIndexes: Array<Int> {
        get {
            var selectedIndexes: Array<Int> = []
            for i in 0..<self.controlViewControllers.count {
                if self.controlViewControllers[i].isSelected {
                    selectedIndexes.append(i)
                }
            }
            return selectedIndexes
        }
    }
    
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
        self.configurations = configs
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
            let hdid = highDegIds[i]
            self.configurations.highDegreeControlSettings[i].id = hdid // TODO: hot fix. need refactoring
            let hds = configs.highDegreeControlSettings[i]
            let ps = hds.indexesOfPatternControlled.map({Utilities.tryAccessArray(array: patterns, index: $0)})
            
            switch hds.highDegCtrlSchemeSetting {
            case .basicScheme:
                hdcvc = HighDegCtrlViewControllerBatchEditing.init(id: hdid, frame: hdControlFrames[i], patterns: ps)
            case .testScheme:
                hdcvc = MockHighDegCtrlViewController.init(id: hdid, frame: hdControlFrames[i], patterns: ps)
            }
            hdcvc.patternsDelegate = delegate
            self.addChild(hdcvc)
            self.view.addSubview(hdcvc.view)
            hdcvc.didMove(toParent: self)
        }
        
        self.controlViewControllers = Array(self.children.dropLast(highDegIds.count)) as? [CtrlViewController]
        self.highDegControlViewControllers = Array(self.children.dropFirst(ids.count)) as? [HighDegCtrlViewController]
    }
    
    func updatePatterns(newPatterns: Array<Pattern>, exceptForIDs: Array<String>?) {
        var ctrlVCs: Array<CtrlViewController> = []
        var hdCtrlVCs: Array<HighDegCtrlViewController> = []
        
        for child in self.children {
            if let cvc = child as? CtrlViewController {
                ctrlVCs.append(cvc)
            }
            if let hdcvc = child as? HighDegCtrlViewController {
                hdCtrlVCs.append(hdcvc)
            }
        }
        
        guard ctrlVCs.count == newPatterns.count else {
            print("update patterns failed: input is of incorrect length")
            return
        }
        
        for i in 0..<ctrlVCs.count {
            if let efids = exceptForIDs {
                guard !efids.contains(ctrlVCs[i].id) else {
                    continue
                }
            }
            ctrlVCs[i].matchControlsWithModel(pattern: newPatterns[i])
        }
        for i in 0..<hdCtrlVCs.count {
            if let efids = exceptForIDs {
                guard !efids.contains(hdCtrlVCs[i].id) else {
                    continue
                }
            }
            let hdcs = self.configurations.highDegreeControlSettings[i]
            let ps = hdcs.indexesOfPatternControlled.map({Utilities.tryAccessArray(array: newPatterns, index: $0)})
            hdCtrlVCs[i].matchControlsWithModel(patterns: ps) // this has to be only the patterns it cares about
        }
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

extension ControlsViewController: ControlsManager {
    
}
