//
//  ViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-25.
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
class MainViewController: UIViewController {
    @IBOutlet weak var gearButton: UIButton!
    @IBOutlet weak var fileButton: UIButton!
    private var moireModel: MoireModel = MoireModel.init()
    var moireIdToInit: String?
    private var currentMoire: Moire?
    var initSettings: InitSettings?
    private var ctrlAndPatternMatcher = CtrlAndPatternMatcher()
    
    private weak var moireViewController: MoireViewController?
    private weak var controlsViewController: ControlsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup MoireViewController
        let mvc = MoireViewController()
        self.addChild(mvc)
        mvc.view.frame = self.view.bounds
        self.view.addSubview(mvc.view)
        mvc.didMove(toParent: self)
        self.moireViewController = mvc
        // setup ControlsViewController
        let cvc = ControlsViewController()
        self.addChild(cvc)
        cvc.view.frame = self.view.bounds
        self.view.addSubview(cvc.view)
        cvc.didMove(toParent: self)
        self.controlsViewController = cvc
        // setup Buttons
        self.view.bringSubviewToFront(gearButton)
        self.view.bringSubviewToFront(fileButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set up must be done in the order below!
        self.initCurrentMoire()
        self.initInitSettings()
        self.initMainView()
        self.initControls()
    }
    
    func updateMainView() {
        if self.initSettings == nil {
            self.initInitSettings()
        }
        if self.currentMoire == nil || self.moireIdToInit != self.currentMoire?.id {
            self.initCurrentMoire()
        }
        self.moireViewController!.resetMoireView(patterns: self.currentMoire!.patterns, settings: self.initSettings!)
        self.initControls()
    }
    
    func initCurrentMoire() {
        if let miti = self.moireIdToInit {
            print("init moire from id: " + miti)
            self.currentMoire = self.moireModel.read(moireId: miti)
        } else {
            self.currentMoire = self.moireModel.readLastCreatedOrEdited() ?? self.moireModel.createNew()
        }
    }
    
    func initInitSettings() {
        func saveInitSettings() {
            do {
                UserDefaults.standard.set(try PropertyListEncoder().encode(self.initSettings), forKey: "InitSettings")
            } catch {
                print("problem saving initSettings to disk")
            }
        }
        guard self.initSettings == nil else {
            saveInitSettings()
            return
        }
        do {
            guard let data = UserDefaults.standard.value(forKey: "InitSettings") as? Data else {throw NSError()}
            self.initSettings = try PropertyListDecoder().decode(InitSettings.self, from: data)
        } catch {
            print("problem loading initSettings from disk; setting and saving the default")
            self.initSettings = InitSettings()
            saveInitSettings()
        }
    }
    
    func initMainView() {
        self.moireViewController!.setUp(patterns: currentMoire!.patterns, settings: self.initSettings!)
    }
    
    func initControls() {
        self.controlsViewController!.reset(patterns: self.currentMoire!.patterns, settings: self.initSettings!, matcher: self.ctrlAndPatternMatcher, delegate: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension MainViewController {
    func saveMoire() -> Bool {
        // save preview
        if let img = self.moireViewController!.takeMoireScreenshot() {
            self.currentMoire?.preview = img
        } else {print("failed to take screenshot")}
        // write to disk
        if let cm = self.currentMoire {
            return self.moireModel.saveOrModify(moire: cm)
        } else {
            print("cannot save current moire because it's nil")
            return false
        }
    }
    
    func pauseMoire() {
        self.moireViewController!.viewControllerLosingFocus()
    }
}

extension MainViewController {
    @IBAction func gearButtonPressed(_ sender: Any) {
        _ = self.saveMoire()
        performSegue(withIdentifier: "showSettingsView", sender: self.gearButton)
    }
    
    @IBAction func fileButtonPressed(_ sender: Any) {
        _ = self.saveMoire()
        performSegue(withIdentifier: "showSaveFilesView", sender: self.fileButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let s = sender as? UIButton {
            switch s {
            case self.gearButton!:
                let svc: SettingsViewController = segue.destination as! SettingsViewController
                if let currentSettings = self.initSettings {
                    svc.initSettings = currentSettings
                }
            case self.fileButton!:
                let sfvc: SaveFilesViewController = segue.destination as! SaveFilesViewController
                sfvc.currentMoireId = self.currentMoire?.id
            default:
                break
            }
        }
        self.pauseMoire()
    }
}

extension MainViewController: PatternManager {
    func highlightPattern(caller: CtrlViewController) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.findIndexOfPatternControlled(controlViewController: caller) else {
            return false
        }
        self.moireViewController!.highlightPatternView(patternViewIndex: index)
        return true
    }
    
    func unhighlightPattern(caller: CtrlViewController) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.findIndexOfPatternControlled(controlViewController: caller) else {
            return false
        }
        self.moireViewController!.unhighlightPatternView(patternViewIndex: index)
        return true
    }
    
    func dimPattern(caller: CtrlViewController) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.findIndexOfPatternControlled(controlViewController: caller) else {
            return false
        }
        self.moireViewController!.dimPatternView(patternViewIndex: index)
        return true
    }
    
    func undimPattern(caller: CtrlViewController) -> Bool {
        guard self.ctrlAndPatternMatcher.findIndexOfPatternControlled(controlViewController: caller) != nil else {
            return false
        }
        self.moireViewController!.undimPatternViews()
        return true
    }
    
    func modifyPattern(speed: CGFloat, caller: CtrlViewController) -> Bool {
        print("setting speed to: ", speed)
        guard Constants.Bounds.speedRange.contains(speed) else {
            print("speed out of bound")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.findIndexOfPatternControlled(controlViewController: caller) else {
            return false
        }
        currentMoire!.patterns[index].speed = speed
        self.moireViewController!.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
        return true
    }
    
    func modifyPattern(direction: CGFloat, caller: CtrlViewController) -> Bool {
        guard Constants.Bounds.directionRange.contains(direction) else {
            print("direction out of bound")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.findIndexOfPatternControlled(controlViewController: caller) else {
            return false
        }
        currentMoire!.patterns[index].direction = direction
        self.moireViewController!.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
        return true
    }
    
    func modifyPattern(blackWidth: CGFloat, caller: CtrlViewController) -> Bool {
        print("setting blackWidth to: ", blackWidth)
        guard Constants.Bounds.blackWidthRange.contains(blackWidth) else {
            print("blackWidth out of bound")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.findIndexOfPatternControlled(controlViewController: caller) else {
            return false
        }
        currentMoire!.patterns[index].blackWidth = blackWidth
        self.moireViewController!.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
        return true
    }
    
    func modifyPattern(whiteWidth: CGFloat, caller: CtrlViewController) -> Bool {
        guard Constants.Bounds.whiteWidthRange.contains(whiteWidth) else {
            print("whiteWidth out of bound")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.findIndexOfPatternControlled(controlViewController: caller) else {
            return false
        }
        currentMoire!.patterns[index].whiteWidth = whiteWidth
        self.moireViewController! .modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
        return true
    }
    
    func getPattern(caller: CtrlViewController) -> Pattern? {
        guard let i = caller.id else {
            return nil
        }
        return self.currentMoire!.patterns[self.ctrlAndPatternMatcher.getIndexOfPatternControlled(id: i)]
    }
}

