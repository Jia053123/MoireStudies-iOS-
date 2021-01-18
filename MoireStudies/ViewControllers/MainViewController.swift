//
//  ViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-25.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var gearButton: UIButton!
    @IBOutlet weak var fileButton: UIButton!
    private var moireModel: MoireModel = MoireModel.init()
    var moireIdToInit: String?
    private var currentMoire: Moire?
    var initSettings: InitSettings?
    private var controlFrames: Array<CGRect> = Constants.UI.defaultControlFrames
    private var controlViewControllers: Array<CtrlViewTarget> = []
    private var mainView: MainView? {
        get {
            return self.view as? MainView
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("MainViewController: view will appear")
        super.viewWillAppear(animated)
        self.initCurrentMoire()
        self.initInitSettings()
        self.initMainView()
        self.initControlViews()
    }
    
    func resetMainView() {
        if self.initSettings == nil {
            self.initInitSettings()
        }
        if self.currentMoire == nil {
            self.initCurrentMoire()
        }
        self.mainView!.resetMoireView(patterns: self.currentMoire!.patterns)
        if self.controlViewControllers.count != self.currentMoire!.patterns.count {
            for cvc in self.controlViewControllers {
                cvc.view.removeFromSuperview()
            }
            self.controlViewControllers = []
            self.initControlViews()
        }
    }
    
    func initCurrentMoire() {
        if let miti = self.moireIdToInit {
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
        self.mainView!.setUp(patterns: currentMoire!.patterns)
    }
    
    func initControlViews() {
        assert(controlFrames.count >= currentMoire!.patterns.count)
        
        for i in 0..<currentMoire!.patterns.count {
            var cvc: CtrlViewTarget?
            switch self.initSettings!.interfaceSetting {
            case UISettings.controlScheme1Slider:
                cvc = CtrlViewControllerSch1.init(id: self.getCtrlViewControllerId(index: i),
                                                      frame: controlFrames[i],
                                                      pattern: currentMoire!.patterns[i])
            case UISettings.controlScheme2Slider:
                cvc = CtrlViewControllerSch2.init(id: self.getCtrlViewControllerId(index: i),
                                                      frame: controlFrames[i],
                                                      pattern: currentMoire!.patterns[i])
            case UISettings.controlScheme1Gesture:
                cvc = CtrlViewControllerSch1.init(id: self.getCtrlViewControllerId(index: i),
                                                      frame: controlFrames[i],
                                                      pattern: currentMoire!.patterns[i])
            }
            cvc!.delegate = self
            let mv = self.mainView!
            mv.addSubview(cvc!.view)
            controlViewControllers.append(cvc!)
            // set up mask for each of the control view
            if (i == 0) {
                mv.setUpMaskOnPatternView(patternIndex: 0, controlViewFrame: controlFrames[1])
            } else if (i == 1) {
                mv.setUpMaskOnPatternView(patternIndex: 1, controlViewFrame: controlFrames[0])
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension MainViewController {
    func saveMoire() -> Bool {
        // save preview
        if let img = self.mainView!.takeMoireScreenshot() {
            self.currentMoire?.preview = img
        } else {print("failed to take screenshot")}
        // write to disk
        if let cm = self.currentMoire {
            return self.moireModel.save(moire: cm)
        } else {
            print("cannot save current moire because it's nil")
            return false
        }
    }
    
    func pauseMoire() {
        self.mainView!.pauseMoire()
    }
    
    func resumeMoire() { // FIX: calling this after pause breaks the animation
        self.mainView!.resumeMoire()
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
                sfvc.selectedMoireId = self.currentMoire?.id
            default:
                break
            }
        }
        self.pauseMoire()
    }
}

extension MainViewController: PatternManager {
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
    
    func highlightPattern(caller: CtrlViewTarget) -> Bool {
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        let mv = self.mainView!
        mv.highlightPatternView(patternViewIndex: index)
        return true
    }
    
    func unhighlightPattern(caller: CtrlViewTarget) -> Bool {
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        let mv = self.mainView!
        mv.unhighlightPatternView(patternViewIndex: index)
        return true
    }
    
    func modifyPattern(speed: CGFloat, caller: CtrlViewTarget) -> Bool {
        print("setting speed to: ", speed)
        guard Constants.Bounds.speedRange.contains(speed) else {
            return false
        }
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        currentMoire!.patterns[index].speed = speed
        let mv = self.mainView!
        mv.modifiyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
        return true
    }
    
    func modifyPattern(direction: CGFloat, caller: CtrlViewTarget) -> Bool {
        print("setting direction to: ", direction)
        guard Constants.Bounds.directionRange.contains(direction) else {
            return false
        }
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        currentMoire!.patterns[index].direction = direction
        let mv = self.mainView!
        mv.modifiyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
        return true
    }
    
    func modifyPattern(fillRatio: CGFloat, caller: CtrlViewTarget) -> Bool {
        print("setting fillRatio to: ", fillRatio)
        guard Constants.Bounds.fillRatioRange.contains(fillRatio) else {
            return false
        }
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        currentMoire!.patterns[index].fillRatio = fillRatio
        let mv = self.mainView!
        mv.modifiyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
        return true
    }
    
    func modifyPattern(scaleFactor: CGFloat, caller: CtrlViewTarget) -> Bool {
        print("setting scaleFactor to: ", scaleFactor)
        guard Constants.Bounds.scaleFactorRange.contains(scaleFactor) else {
            return false
        }
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        currentMoire!.patterns[index].scaleFactor = scaleFactor
        let mv = self.mainView!
        mv.modifiyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
        return true
    }
    
    func getPattern(caller: CtrlViewTarget) -> Pattern? {
        guard let i = caller.id else {
            return nil
        }
        return self.currentMoire!.patterns[getCtrlViewControllerIndex(id: i)]
    }
}

