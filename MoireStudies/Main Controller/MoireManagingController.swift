//
//  MoireManagingController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-05-01.
//

import Foundation
import UIKit

/**
 View Hierarchy:
 - MainViewController
    - UIButton
    - ControlsViewContainerController
        - ControlViewController (n)
    - MoireViewController (1)
        - DimView (0..1)
        - PatternViewController (n)
            - MaskView(1) in mask property
 */
class MoireManagingController: UIViewController {
    private var moireModelAccessor: MoireModelAccessor!
    private weak var moireViewController: MoireViewController!
    var moireDisplayer: MoireDisplayer { get{ return self.moireViewController } }
    private weak var controlsViewController: ControlsViewController!
    var patternsSelector: PatternsSelector { get{ return self.controlsViewController } }
    private var ctrlAndPatternMatcher = CtrlAndPatternMatcher()
    var configurations: Configurations?
    var moireIdToInit: String?
    private(set) var currentMoire: Moire?
    
    func setUpModelAndChildControllers(moireModel: MoireModel = LocalMoireModel.init(),
                                       moireViewController: MoireViewController = MoireViewController(),
                                       controlsViewController: ControlsViewController = ControlsViewController()) {
        // setup MoireModel
        self.moireModelAccessor = MoireModelAccessor.init(moireModel: moireModel, screenshotProvider: moireViewController)
        // setup MoireViewController
        self.addChild(moireViewController)
        self.moireViewController = moireViewController
        // setup ControlsViewController
        self.addChild(controlsViewController)
        self.controlsViewController = controlsViewController
    }
    
    init?(coder: NSCoder, mockMoireModel: MoireModel, mockMoireViewController: MoireViewController, mockControlsViewController: ControlsViewController) {
        super.init(coder: coder)
        self.setUpModelAndChildControllers(moireModel: mockMoireModel,
                                           moireViewController: mockMoireViewController,
                                           controlsViewController: mockControlsViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setUpModelAndChildControllers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpModelAndChildControllers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup MoireViewController
        self.moireViewController.view.frame = self.view.bounds
        self.view.addSubview(self.moireViewController.view)
        self.moireViewController.didMove(toParent: self)
        // setup ControlsViewController
        self.controlsViewController.view.frame = self.view.bounds
        self.view.addSubview(self.controlsViewController.view)
        self.controlsViewController.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set up must be done in the order below!
        self.initCurrentMoire()
        self.initConfigs()
        self.initMainView()
        self.initControls()
    }
    
    func updateMainView() {
        if self.configurations == nil {
            self.initConfigs()
        }
        if self.currentMoire == nil || ((self.moireIdToInit != nil) && (self.moireIdToInit != self.currentMoire?.id)) {
            self.initCurrentMoire()
        }
        self.moireViewController.resetMoireView(patterns: self.currentMoire!.patterns, configs: self.configurations!)
        self.resetControls()
    }
    
    func initCurrentMoire() {
        self.currentMoire = self.moireModelAccessor.loadMoire(preferredId: self.moireIdToInit)
    }
    
    func initConfigs() {
        func saveInitSettings() {
            do {
                UserDefaults.standard.set(try PropertyListEncoder().encode(self.configurations), forKey: "InitSettings")
            } catch {
                print("problem saving initSettings to disk")
            }
        }
        guard self.configurations == nil else {
            saveInitSettings()
            return
        }
        do {
            guard let data = UserDefaults.standard.value(forKey: "InitSettings") as? Data else {throw NSError()}
            self.configurations = try PropertyListDecoder().decode(Configurations.self, from: data)
        } catch {
            print("problem loading initSettings from disk; setting and saving the default")
            self.configurations = Configurations()
            saveInitSettings()
        }
    }
    
    func initMainView() {
        self.moireViewController.setUp(patterns: currentMoire!.patterns, configs: self.configurations!)
    }
    
    func initControls() {
        var ids: Array<String> = []
        for i in 0..<self.currentMoire!.patterns.count {
            ids.append(self.ctrlAndPatternMatcher.getOrCreateCtrlViewControllerId(indexesOfPatternControlled: [i])!)
        }
        var hdIds: Array<String> = []
        for i in 0..<self.configurations!.highDegreeControlCount {
            let indexes = self.configurations!.highDegreeControlSettings[i].indexesOfPatternControlled
            if let newId = self.ctrlAndPatternMatcher.getOrCreateCtrlViewControllerId(indexesOfPatternControlled: indexes) {
                hdIds.append(newId)
            }
        }
        self.controlsViewController.setUp(patterns: self.currentMoire!.patterns, configs: self.configurations!, ids: ids, highDegIds: hdIds, delegate: self)
    }
    
    func resetControls() {
        self.initControls()
    }

    func createHighDegControl(type: HighDegreeControlSettings, patternsToControl: Array<Int>) -> Bool {
        // TODO: stub
        return false
    }
    
    func saveMoire() -> Bool {
        guard let cm = self.currentMoire else {
            print("cannot save current moire because it's nil")
            return false
        }
        return self.moireModelAccessor.saveMoire(moireToSave: cm)
    }
}

extension MoireManagingController: PatternManager {
    func highlightPattern(callerId: String) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return false}
        self.moireViewController.highlightPatternView(patternViewIndex: index)
        return true
    }
    
    func unhighlightPattern(callerId: String) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return false}
        self.moireViewController.unhighlightPatternView(patternViewIndex: index)
        return true
    }
    
    func dimPattern(callerId: String) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return false}
        self.moireViewController.dimPatternView(patternViewIndex: index)
        return true
    }
    
    func undimPattern(callerId: String) -> Bool {
        guard self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId) != nil else {return false}
        self.moireViewController.undimPatternViews()
        return true
    }
    
    private func modifyPattern(speed: CGFloat, patternIndex: Int) -> Bool {
        guard BoundsManager.speedRange.contains(speed) else {
            print("speed out of bound")
            return false
        }
        currentMoire!.patterns[patternIndex].speed = speed
        return true
    }
    
    func modifyPattern(speed: CGFloat, callerId: String) -> Bool {
        guard self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.count == 1 else {
            print("called modifyPattern with a high degree id")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {
            print("can't find id")
            return false
        }
        let success = self.modifyPattern(speed: speed, patternIndex: index)
        if success {
            self.moireViewController.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
            return true
        } else {
            return false
        }
    }
    
    private func modifyPattern(direction: CGFloat, patternIndex: Int) -> Bool {
        guard BoundsManager.directionRange.contains(direction) else {
            print("direction out of bound")
            return false
        }
        currentMoire!.patterns[patternIndex].direction = direction
        return true
    }
    
    func modifyPattern(direction: CGFloat, callerId: String) -> Bool {
        guard self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.count == 1 else {
            print("called modifyPattern with a high degree id")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {
            print("can't find id")
            return false
        }
        let success = self.modifyPattern(direction: direction, patternIndex: index)
        if success {
            self.moireViewController.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
            return true
        } else {
            return false
        }
    }
    
    private func modifyPattern(blackWidth: CGFloat, patternIndex: Int) -> Bool {
        guard BoundsManager.blackWidthRange.contains(blackWidth) else {
            print("blackWidth out of bound")
            return false
        }
        currentMoire!.patterns[patternIndex].blackWidth = blackWidth
        return true
    }
    
    func modifyPattern(blackWidth: CGFloat, callerId: String) -> Bool {
        guard self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.count == 1 else {
            print("called modifyPattern with a high degree id")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {
            print("can't find id")
            return false
        }
        let success = self.modifyPattern(blackWidth: blackWidth, patternIndex: index)
        if success {
            self.moireViewController.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
            return true
        } else {
            return false
        }
    }
    
    private func modifyPattern(whiteWidth: CGFloat, patternIndex: Int) -> Bool {
        guard BoundsManager.whiteWidthRange.contains(whiteWidth) else {
            print("whiteWidth out of bound")
            return false
        }
        currentMoire!.patterns[patternIndex].whiteWidth = whiteWidth
        return true
    }
    
    func modifyPattern(whiteWidth: CGFloat, callerId: String) -> Bool {
        guard self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.count == 1 else {
            print("called modifyPattern with a high degree id")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {
            print("can't find id")
            return false
        }
        let success = self.modifyPattern(whiteWidth: whiteWidth, patternIndex: index)
        if success {
            self.moireViewController.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
            return true
        } else {
            return false
        }
    }
    
    func modifyPatterns(modifiedPatterns: Array<Pattern>, callerId: String) -> Bool {
        guard let patternIndexes = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId) else {
            return false
        }
        // if array length is wrong, return false
        guard modifiedPatterns.count == patternIndexes.count else {
            return false
        }
        // if not all the changes are legal, apply what is legal, and return false
        var completeSuccess = true
        for i in 0..<patternIndexes.count {
            let newPattern = modifiedPatterns[i]
            let patternIndex = patternIndexes[i]
            var success = true
            success = self.modifyPattern(speed: newPattern.speed, patternIndex: patternIndex)
            completeSuccess = completeSuccess && success
            success = self.modifyPattern(direction: newPattern.direction, patternIndex: patternIndex)
            completeSuccess = completeSuccess && success
            success = self.modifyPattern(blackWidth: newPattern.blackWidth, patternIndex: patternIndex)
            completeSuccess = completeSuccess && success
            success = self.modifyPattern(whiteWidth: newPattern.whiteWidth, patternIndex: patternIndex)
            completeSuccess = completeSuccess && success
            
            self.moireViewController.modifyPatternView(patternViewIndex: patternIndex, newPattern: currentMoire!.patterns[patternIndex])
        }
        return completeSuccess
    }
    
    func retrievePattern(callerId: String) -> Pattern? {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return nil}
        return self.currentMoire!.patterns[index]
    }
    
    func retrievePatterns(callerId: String) -> Array<Pattern>? {
        // TODO: stub
        return nil
    }
    
    func hidePattern(callerId: String) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return false}
        self.moireViewController?.hidePatternView(patternViewIndex: index)
        return true
    }
    
    func unhidePattern(callerId: String) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return false}
        self.moireViewController?.unhidePatternView(patternViewIndex: index)
        return true
    }
    
    func createPattern(callerId: String?, newPattern: Pattern) -> Bool {
        guard self.currentMoire!.patterns.count < Constants.Constrains.numOfPatternsPerMoire.upperBound else {
            print("creation failed: maximum number of patterns per moire reached")
            return false
        }
        if let cId = callerId {
            if let pIndex = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: cId)?.first {
                self.currentMoire!.patterns.insert(newPattern, at: pIndex+1)
            }
        } else {
            self.currentMoire!.patterns.append(newPattern)
        }
        self.updateMainView()
        print("num of patterns after creating new: ", self.currentMoire!.patterns.count)
        return true
    }
    
    func deletePattern(callerId: String) -> Bool {
        guard self.currentMoire!.patterns.count > Constants.Constrains.numOfPatternsPerMoire.lowerBound else {
            print("deletion failed: minimum number of patterns per moire reached")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return false}
        self.currentMoire!.patterns.remove(at: index)
        print("num of patterns after deletion: ", self.currentMoire!.patterns.count)
        self.updateMainView()
        return true
    }
}
